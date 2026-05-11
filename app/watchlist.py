"""Watchlist: add, remove, view (Q6)."""
from flask import Blueprint, flash, redirect, render_template, request, session, url_for
from mysql.connector.errors import IntegrityError

from .auth import login_required
from .db import execute, query_all

bp = Blueprint("watchlist", __name__)


# ------------------------------------------------------------
#  Q6: My watchlist with current standings.
# ------------------------------------------------------------
@bp.route("/")
@login_required
def view():
    uid = session["user_id"]
    rows = query_all(
        """
        SELECT
            w.added_at,
            a.auction_id, a.current_price, a.end_time, a.status,
            i.title,
            seller.username                    AS seller_username,
            (a.high_bidder_id = %s)            AS is_high_bidder,
            COALESCE(bc.bid_count, 0)          AS bid_count,
            fn_is_auction_active(a.auction_id) AS is_active
        FROM Watchlist w
        JOIN Auctions a      ON w.auction_id = a.auction_id
        JOIN Items    i      ON a.item_id    = i.item_id
        JOIN Users    seller ON i.seller_id  = seller.user_id
        LEFT JOIN (
            SELECT auction_id, COUNT(*) AS bid_count
            FROM Bids GROUP BY auction_id
        ) bc ON bc.auction_id = a.auction_id
        WHERE w.user_id = %s
        ORDER BY a.end_time ASC
        """,
        (uid, uid),
    )
    return render_template("watchlist.html", entries=rows)


@bp.route("/<int:auction_id>/add", methods=["POST"])
@login_required
def add(auction_id: int):
    try:
        execute(
            "INSERT INTO Watchlist (user_id, auction_id) VALUES (%s, %s)",
            (session["user_id"], auction_id),
        )
        flash("Added to watchlist.", "success")
    except IntegrityError:
        flash("Already on your watchlist.", "info")
    return redirect(request.referrer or url_for("auctions.detail",
                                                auction_id=auction_id))


@bp.route("/<int:auction_id>/remove", methods=["POST"])
@login_required
def remove(auction_id: int):
    execute(
        "DELETE FROM Watchlist WHERE user_id = %s AND auction_id = %s",
        (session["user_id"], auction_id),
    )
    flash("Removed from watchlist.", "info")
    return redirect(request.referrer or url_for("watchlist.view"))
