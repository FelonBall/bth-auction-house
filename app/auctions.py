"""Auction browse / view / create routes."""
from datetime import datetime, timedelta

from flask import (Blueprint, flash, redirect, render_template, request,
                   session, url_for)
from mysql.connector.errors import DatabaseError

from .auth import login_required
from .db import callproc, cursor, query_all, query_one

bp = Blueprint("auctions", __name__)


def _close_expired_silently():
    """Run sp_close_expired_auctions before listing pages so closed auctions
    are reflected in the UI without a separate scheduler."""
    try:
        callproc("sp_close_expired_auctions")
    except Exception:
        # Don't break the page if the procedure call fails.
        pass


# ------------------------------------------------------------
#  Q1: Browse active auctions, optional category filter.
# ------------------------------------------------------------
@bp.route("/")
def browse():
    _close_expired_silently()

    category_id = request.args.get("category", type=int)
    categories  = query_all(
        "SELECT category_id, name, parent_id FROM Categories ORDER BY name"
    )

    sql = """
        SELECT
            a.auction_id,
            i.title,
            c.name                    AS category_name,
            u.username                AS seller_username,
            a.current_price,
            a.end_time,
            COALESCE(bc.bid_count, 0) AS bid_count
        FROM Auctions a
        JOIN Items      i  ON a.item_id     = i.item_id
        JOIN Categories c  ON i.category_id = c.category_id
        JOIN Users      u  ON i.seller_id   = u.user_id
        LEFT JOIN (
            SELECT auction_id, COUNT(*) AS bid_count
            FROM Bids GROUP BY auction_id
        ) bc ON bc.auction_id = a.auction_id
        WHERE a.status = 'active'
          AND a.end_time > NOW()
          AND (%s IS NULL OR c.category_id = %s)
        ORDER BY a.end_time ASC
    """
    auctions = query_all(sql, (category_id, category_id))
    return render_template(
        "browse.html",
        auctions=auctions,
        categories=categories,
        selected_category=category_id,
    )


# ------------------------------------------------------------
#  Auction detail: shows item info, bid history, watchlist
#  toggle, and the bid form.
# ------------------------------------------------------------
@bp.route("/<int:auction_id>")
def detail(auction_id: int):
    _close_expired_silently()

    auction = query_one(
        """
        SELECT
            a.auction_id, a.start_price, a.current_price,
            a.start_time, a.end_time, a.status, a.high_bidder_id,
            i.item_id, i.title, i.description, i.item_condition,
            c.category_id, c.name AS category_name,
            u.user_id     AS seller_id,
            u.username    AS seller_username,
            fn_is_auction_active(a.auction_id) AS is_active,
            fn_get_bid_count(a.auction_id)     AS bid_count,
            t.transaction_id  AS tx_id,
            t.sale_price      AS tx_sale_price,
            t.completed_at    AS tx_completed_at,
            buyer.username    AS tx_buyer_username
        FROM Auctions a
        JOIN Items      i      ON a.item_id     = i.item_id
        JOIN Categories c      ON i.category_id = c.category_id
        JOIN Users      u      ON i.seller_id   = u.user_id
        LEFT JOIN Transactions t ON t.auction_id = a.auction_id
        LEFT JOIN Users buyer    ON t.buyer_id   = buyer.user_id
        WHERE a.auction_id = %s
        """,
        (auction_id,),
    )
    if not auction:
        flash("Auction not found.", "danger")
        return redirect(url_for("auctions.browse"))

    bids = query_all(
        """
        SELECT b.amount, b.placed_at, u.username AS bidder_username
        FROM Bids b
        JOIN Users u ON b.bidder_id = u.user_id
        WHERE b.auction_id = %s
        ORDER BY b.placed_at DESC
        """,
        (auction_id,),
    )

    on_watchlist = False
    uid = session.get("user_id")
    if uid:
        on_watchlist = query_one(
            "SELECT 1 FROM Watchlist WHERE user_id = %s AND auction_id = %s",
            (uid, auction_id),
        ) is not None

    return render_template(
        "auction_detail.html",
        a=auction,
        bids=bids,
        on_watchlist=on_watchlist,
    )


# ------------------------------------------------------------
#  Create a new auction (item + auction in one transaction).
# ------------------------------------------------------------
@bp.route("/new", methods=["GET", "POST"])
@login_required
def new():
    categories = query_all(
        "SELECT category_id, name FROM Categories WHERE parent_id IS NOT NULL "
        "ORDER BY name"
    )

    if request.method == "POST":
        try:
            category_id = int(request.form["category_id"])
            title       = request.form["title"].strip()
            description = request.form.get("description", "").strip()
            condition   = request.form["item_condition"]
            start_price = float(request.form["start_price"])
            duration    = int(request.form["duration_days"])
        except (KeyError, ValueError):
            flash("Invalid form data.", "danger")
            return render_template("new_auction.html", categories=categories)

        if not title or start_price <= 0 or duration <= 0:
            flash("Title, positive price, and positive duration are required.",
                  "danger")
            return render_template("new_auction.html", categories=categories)

        end_time = datetime.now() + timedelta(days=duration)
        with cursor(dictionary=False) as cur:
            cur.execute(
                """INSERT INTO Items (seller_id, category_id, title, description,
                                      item_condition)
                   VALUES (%s, %s, %s, %s, %s)""",
                (session["user_id"], category_id, title, description, condition),
            )
            item_id = cur.lastrowid
            cur.execute(
                """INSERT INTO Auctions (item_id, start_price, current_price,
                                         start_time, end_time)
                   VALUES (%s, %s, %s, NOW(), %s)""",
                (item_id, start_price, start_price, end_time),
            )
        flash("Auction created.", "success")
        return redirect(url_for("auctions.browse"))

    return render_template("new_auction.html", categories=categories)


# ------------------------------------------------------------
#  My auctions (auctions I'm selling).
# ------------------------------------------------------------
@bp.route("/mine")
@login_required
def mine():
    rows = query_all(
        """
        SELECT
            a.auction_id, i.title, a.start_price, a.current_price,
            a.start_time, a.end_time, a.status,
            high_bidder.username      AS high_bidder_username,
            COALESCE(bc.bid_count, 0) AS bid_count
        FROM Auctions a
        JOIN Items i           ON a.item_id        = i.item_id
        LEFT JOIN Users high_bidder
                                ON a.high_bidder_id = high_bidder.user_id
        LEFT JOIN (
            SELECT auction_id, COUNT(*) AS bid_count
            FROM Bids GROUP BY auction_id
        ) bc ON bc.auction_id = a.auction_id
        WHERE i.seller_id = %s
        ORDER BY a.end_time DESC
        """,
        (session["user_id"],),
    )
    return render_template("my_auctions.html", auctions=rows)


# ------------------------------------------------------------
#  Q3: My bidding history (with win/loss outcome).
# ------------------------------------------------------------
@bp.route("/my-bids")
@login_required
def my_bids():
    uid = session["user_id"]
    rows = query_all(
        """
        SELECT
            b.bid_id, b.amount, b.placed_at,
            a.auction_id, a.status AS auction_status, a.end_time,
            a.current_price AS current_high_bid,
            i.title,
            seller.username AS seller_username,
            CASE
                WHEN t.buyer_id = %s          THEN 'won'
                WHEN a.status   = 'closed'    THEN 'lost'
                WHEN a.high_bidder_id = %s    THEN 'leading'
                ELSE 'outbid'
            END AS outcome
        FROM Bids b
        JOIN Auctions  a      ON b.auction_id = a.auction_id
        JOIN Items     i      ON a.item_id    = i.item_id
        JOIN Users     seller ON i.seller_id  = seller.user_id
        LEFT JOIN Transactions t ON t.auction_id = a.auction_id
        WHERE b.bidder_id = %s
        ORDER BY b.placed_at DESC
        """,
        (uid, uid, uid),
    )
    return render_template("my_bids.html", bids=rows)


# ------------------------------------------------------------
#  End an auction immediately (seller-only). Calls the
#  sp_end_auction_now procedure, which validates ownership and
#  creates a transaction row if there was a winning bidder.
# ------------------------------------------------------------
@bp.route("/<int:auction_id>/end", methods=["POST"])
@login_required
def end_now(auction_id: int):
    try:
        callproc("sp_end_auction_now", (auction_id, session["user_id"]))
    except DatabaseError as e:
        flash(f"Could not end auction: {e.msg}", "danger")
        return redirect(url_for("auctions.detail", auction_id=auction_id))

    flash("Auction ended.", "success")
    return redirect(url_for("auctions.detail", auction_id=auction_id))
