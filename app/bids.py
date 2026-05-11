"""Place bids."""
from flask import Blueprint, flash, redirect, request, session, url_for
from mysql.connector.errors import DatabaseError

from .auth import login_required
from .db import execute

bp = Blueprint("bids", __name__)


@bp.route("/<int:auction_id>", methods=["POST"])
@login_required
def place(auction_id: int):
    try:
        amount = float(request.form["amount"])
    except (KeyError, ValueError):
        flash("Invalid bid amount.", "danger")
        return redirect(url_for("auctions.detail", auction_id=auction_id))

    if amount <= 0:
        flash("Bid amount must be positive.", "danger")
        return redirect(url_for("auctions.detail", auction_id=auction_id))

    try:
        execute(
            "INSERT INTO Bids (auction_id, bidder_id, amount) VALUES (%s, %s, %s)",
            (auction_id, session["user_id"], amount),
        )
    except DatabaseError as e:
        # SIGNAL from trg_bid_before_insert lands here.
        flash(f"Bid rejected: {e.msg}", "danger")
        return redirect(url_for("auctions.detail", auction_id=auction_id))

    flash(f"Bid of {amount:.2f} placed.", "success")
    return redirect(url_for("auctions.detail", auction_id=auction_id))
