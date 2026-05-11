"""
seed.py  --  Generate fake data for the BTH Auction House database.

Populates Users, Items, Auctions, Bids, Watchlist, then expires a portion
of the auctions and runs sp_close_expired_auctions() so we end up with a
realistic mix of active auctions, closed auctions, and Transactions.

Usage:
    python seed.py
"""

import os
import random
from datetime import datetime, timedelta

import mysql.connector
from dotenv import load_dotenv
from faker import Faker
from werkzeug.security import generate_password_hash

load_dotenv()
fake = Faker()
random.seed(42)
Faker.seed(42)

# -------------------------------------------------------------------
#  Tunables
# -------------------------------------------------------------------
NUM_USERS                 = 30
NUM_ITEMS                 = 80
MAX_BIDS_PER_AUCTION      = 8
WATCHLIST_PER_USER_RANGE  = (0, 5)
EXPIRE_FRACTION           = 0.40   # fraction of auctions we age into the past
TEST_PASSWORD             = "password123"


def get_conn():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        autocommit=False,
    )


REQUIRED_TABLES = [
    "Users", "Categories", "Items", "Auctions",
    "Bids", "Watchlist", "Transactions",
]


def assert_schema_loaded(cur):
    """Fail fast with a clear message if any required table is missing."""
    cur.execute("SHOW TABLES")
    existing = {row[0].lower() for row in cur.fetchall()}
    missing = [t for t in REQUIRED_TABLES if t.lower() not in existing]
    if missing:
        raise RuntimeError(
            f"Schema not fully loaded. Missing tables: {', '.join(missing)}. "
            f"Re-run sql/01_schema.sql via the MySQL `source` command."
        )


def clear_data(cur):
    """Delete data from all tables in FK-safe order, then reset auto-increment."""
    print("Clearing existing data ...")
    tables = ["Transactions", "Watchlist", "Bids", "Auctions", "Items", "Users"]
    for tbl in tables:
        cur.execute(f"DELETE FROM {tbl}")
        cur.execute(f"ALTER TABLE {tbl} AUTO_INCREMENT = 1")


def fetch_leaf_categories(cur):
    """Prefer leaf (sub-)categories; fall back to all categories if none exist."""
    cur.execute("SELECT category_id FROM Categories WHERE parent_id IS NOT NULL")
    rows = [r[0] for r in cur.fetchall()]
    if rows:
        return rows
    cur.execute("SELECT category_id FROM Categories")
    return [r[0] for r in cur.fetchall()]


def create_users(cur):
    print(f"Creating {NUM_USERS} users (password = '{TEST_PASSWORD}') ...")
    pw_hash = generate_password_hash(TEST_PASSWORD)
    user_ids = []
    used_usernames, used_emails = set(), set()

    for _ in range(NUM_USERS):
        while True:
            username = fake.user_name()
            if username not in used_usernames:
                used_usernames.add(username)
                break
        while True:
            email = fake.email()
            if email not in used_emails:
                used_emails.add(email)
                break
        cur.execute(
            "INSERT INTO Users (username, email, password_hash) VALUES (%s, %s, %s)",
            (username, email, pw_hash),
        )
        user_ids.append(cur.lastrowid)
    return user_ids


def create_items_and_auctions(cur, user_ids, leaf_category_ids):
    print(f"Creating {NUM_ITEMS} items + auctions (all initially active) ...")
    conditions = ["new", "like_new", "good", "fair", "poor"]
    auctions = []  # list of dicts tracking each auction for the bid phase

    for _ in range(NUM_ITEMS):
        seller_id   = random.choice(user_ids)
        category_id = random.choice(leaf_category_ids)
        title       = fake.sentence(nb_words=4).rstrip(".")
        description = fake.paragraph(nb_sentences=3)
        condition   = random.choice(conditions)

        cur.execute(
            """INSERT INTO Items (seller_id, category_id, title, description, item_condition)
               VALUES (%s, %s, %s, %s, %s)""",
            (seller_id, category_id, title, description, condition),
        )
        item_id = cur.lastrowid

        # Auction starts somewhere in the last 0-10 days,
        # ends 7-30 days from NOW (always in the future at insert time).
        start_offset_days = random.randint(0, 10)
        end_offset_days   = random.randint(7, 30)
        start_time = datetime.now() - timedelta(days=start_offset_days,
                                                hours=random.randint(0, 23))
        end_time   = datetime.now() + timedelta(days=end_offset_days,
                                                hours=random.randint(0, 23))
        # Whole-kronor prices: 50 kr - 5000 kr, rounded to nearest 10.
        start_price = random.randrange(5, 501) * 10

        cur.execute(
            """INSERT INTO Auctions (item_id, start_price, current_price,
                                     start_time, end_time)
               VALUES (%s, %s, %s, %s, %s)""",
            (item_id, start_price, start_price, start_time, end_time),
        )
        auctions.append({
            "auction_id":    cur.lastrowid,
            "seller_id":     seller_id,
            "current_price": start_price,
        })
    return auctions


def place_bids(cur, conn, auctions, user_ids):
    """Place bids directly; the BEFORE-trigger validates each insert."""
    print("Placing bids ...")
    total = 0
    for a in auctions:
        n_bids = random.randint(0, MAX_BIDS_PER_AUCTION)
        eligible = [uid for uid in user_ids if uid != a["seller_id"]]
        if not eligible:
            continue
        current = a["current_price"]
        for _ in range(n_bids):
            # Integer increment 10-250 kr.
            current += random.randrange(1, 26) * 10
            bidder = random.choice(eligible)
            try:
                cur.execute(
                    "INSERT INTO Bids (auction_id, bidder_id, amount) VALUES (%s, %s, %s)",
                    (a["auction_id"], bidder, current),
                )
                total += 1
            except mysql.connector.Error as e:
                print(f"  bid rejected on auction {a['auction_id']}: {e.msg}")
                conn.rollback()
                continue
        conn.commit()
    print(f"  Placed {total} bids total")


def create_watchlists(cur, user_ids):
    print("Creating watchlist entries ...")
    cur.execute("SELECT auction_id FROM Auctions")
    auction_ids = [r[0] for r in cur.fetchall()]
    if not auction_ids:
        return
    for uid in user_ids:
        n = random.randint(*WATCHLIST_PER_USER_RANGE)
        for aid in random.sample(auction_ids, min(n, len(auction_ids))):
            try:
                cur.execute(
                    "INSERT INTO Watchlist (user_id, auction_id) VALUES (%s, %s)",
                    (uid, aid),
                )
            except mysql.connector.IntegrityError:
                pass


def expire_some_auctions(cur):
    """
    Move ~40% of auctions' end_time into the past so we can demonstrate
    sp_close_expired_auctions(). We bypass triggers by writing directly to
    the Auctions table (no triggers defined on UPDATE).
    """
    print(f"Aging {int(EXPIRE_FRACTION * 100)}% of auctions into the past ...")
    cur.execute("SELECT auction_id FROM Auctions")
    aids = [r[0] for r in cur.fetchall()]
    to_expire = random.sample(aids, k=int(len(aids) * EXPIRE_FRACTION))
    for aid in to_expire:
        new_start = datetime.now() - timedelta(days=14)
        new_end   = datetime.now() - timedelta(days=random.randint(1, 5))
        cur.execute(
            "UPDATE Auctions SET start_time=%s, end_time=%s WHERE auction_id=%s",
            (new_start, new_end, aid),
        )


def close_expired(cur):
    print("Calling sp_close_expired_auctions() ...")
    cur.callproc("sp_close_expired_auctions")


def print_stats(cur):
    print("\n--- Database summary ---")
    queries = [
        ("Users",                    "SELECT COUNT(*) FROM Users"),
        ("Categories",               "SELECT COUNT(*) FROM Categories"),
        ("Items",                    "SELECT COUNT(*) FROM Items"),
        ("Auctions (total)",         "SELECT COUNT(*) FROM Auctions"),
        ("  active",                 "SELECT COUNT(*) FROM Auctions WHERE status='active'"),
        ("  closed",                 "SELECT COUNT(*) FROM Auctions WHERE status='closed'"),
        ("Bids",                     "SELECT COUNT(*) FROM Bids"),
        ("Watchlist entries",        "SELECT COUNT(*) FROM Watchlist"),
        ("Transactions",             "SELECT COUNT(*) FROM Transactions"),
    ]
    for label, q in queries:
        cur.execute(q)
        print(f"  {label:<20s} {cur.fetchone()[0]}")
    print(f"\nAll users share the password: '{TEST_PASSWORD}'")


def main():
    conn = get_conn()
    cur  = conn.cursor()
    try:
        assert_schema_loaded(cur)
        clear_data(cur)
        conn.commit()

        leaf_cats = fetch_leaf_categories(cur)
        user_ids  = create_users(cur)
        conn.commit()

        auctions = create_items_and_auctions(cur, user_ids, leaf_cats)
        conn.commit()

        place_bids(cur, conn, auctions, user_ids)

        create_watchlists(cur, user_ids)
        conn.commit()

        expire_some_auctions(cur)
        conn.commit()

        close_expired(cur)
        conn.commit()

        print_stats(cur)
    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    main()
