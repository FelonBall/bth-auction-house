"""My Transactions page — purchases (rows where I am the buyer) and
sales (rows where I am the seller)."""
from flask import Blueprint, render_template, session

from .auth import login_required
from .db import query_all, query_one

bp = Blueprint("transactions", __name__)


@bp.route("/")
@login_required
def view():
    uid = session["user_id"]

    purchases = query_all(
        """
        SELECT
            t.transaction_id, t.sale_price, t.completed_at,
            i.title,
            seller.username     AS seller_username,
            a.auction_id,
            c.name              AS category_name
        FROM Transactions t
        JOIN Auctions   a       ON t.auction_id  = a.auction_id
        JOIN Items      i       ON a.item_id     = i.item_id
        JOIN Categories c       ON i.category_id = c.category_id
        JOIN Users      seller  ON t.seller_id   = seller.user_id
        WHERE t.buyer_id = %s
        ORDER BY t.completed_at DESC
        """,
        (uid,),
    )

    sales = query_all(
        """
        SELECT
            t.transaction_id, t.sale_price, t.completed_at,
            i.title,
            buyer.username      AS buyer_username,
            a.auction_id,
            c.name              AS category_name
        FROM Transactions t
        JOIN Auctions   a       ON t.auction_id  = a.auction_id
        JOIN Items      i       ON a.item_id     = i.item_id
        JOIN Categories c       ON i.category_id = c.category_id
        JOIN Users      buyer   ON t.buyer_id    = buyer.user_id
        WHERE t.seller_id = %s
        ORDER BY t.completed_at DESC
        """,
        (uid,),
    )

    totals = query_one(
        """
        SELECT
            COALESCE(SUM(CASE WHEN buyer_id  = %s THEN sale_price END), 0) AS spent,
            COALESCE(SUM(CASE WHEN seller_id = %s THEN sale_price END), 0) AS earned,
            COUNT(CASE WHEN buyer_id  = %s THEN 1 END) AS purchases_count,
            COUNT(CASE WHEN seller_id = %s THEN 1 END) AS sales_count
        FROM Transactions
        WHERE buyer_id = %s OR seller_id = %s
        """,
        (uid, uid, uid, uid, uid, uid),
    )

    return render_template(
        "transactions.html",
        purchases=purchases,
        sales=sales,
        totals=totals,
    )
