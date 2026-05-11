"""Aggregate / leaderboard pages (Q2, Q4, Q5)."""
from flask import Blueprint, render_template

from .db import query_all

bp = Blueprint("stats", __name__)


@bp.route("/")
def overview():
    # ------------------------------------------------------------
    #  Q2: Top 5 sellers by total sale value (last 30 days).
    # ------------------------------------------------------------
    top_sellers = query_all(
        """
        SELECT
            u.user_id, u.username,
            COUNT(*)          AS sales_count,
            SUM(t.sale_price) AS total_revenue,
            AVG(t.sale_price) AS avg_sale_price
        FROM Transactions t
        JOIN Users u ON t.seller_id = u.user_id
        WHERE t.completed_at >= (NOW() - INTERVAL 30 DAY)
        GROUP BY u.user_id, u.username
        ORDER BY total_revenue DESC
        LIMIT 5
        """
    )

    # ------------------------------------------------------------
    #  Q4: Auctions ending in the next 24 hours.
    # ------------------------------------------------------------
    ending_soon = query_all(
        """
        SELECT
            a.auction_id, i.title, a.current_price, a.end_time,
            TIMESTAMPDIFF(MINUTE, NOW(), a.end_time) AS minutes_remaining,
            COALESCE(bc.bid_count, 0)                AS bid_count
        FROM Auctions a
        JOIN Items i ON a.item_id = i.item_id
        LEFT JOIN (
            SELECT auction_id, COUNT(*) AS bid_count
            FROM Bids GROUP BY auction_id
        ) bc ON bc.auction_id = a.auction_id
        WHERE a.status   = 'active'
          AND a.end_time > NOW()
          AND a.end_time <= (NOW() + INTERVAL 24 HOUR)
        ORDER BY bid_count DESC, a.end_time ASC
        """
    )

    # ------------------------------------------------------------
    #  Q5: Category leaderboard (avg sale price + counts).
    # ------------------------------------------------------------
    category_board = query_all(
        """
        SELECT
            c.category_id, c.name AS category_name,
            COUNT(t.transaction_id) AS sales_count,
            AVG(t.sale_price)       AS avg_sale_price,
            MIN(t.sale_price)       AS min_sale_price,
            MAX(t.sale_price)       AS max_sale_price
        FROM Categories c
        JOIN Items        i ON i.category_id = c.category_id
        JOIN Auctions     a ON a.item_id     = i.item_id
        JOIN Transactions t ON t.auction_id  = a.auction_id
        GROUP BY c.category_id, c.name
        HAVING sales_count > 0
        ORDER BY avg_sale_price DESC
        """
    )

    # ------------------------------------------------------------
    #  Recent sales — most recent transactions across the whole
    #  marketplace. Five-relation join.
    # ------------------------------------------------------------
    recent_sales = query_all(
        """
        SELECT
            t.transaction_id, t.sale_price, t.completed_at,
            i.title,
            c.name              AS category_name,
            buyer.username      AS buyer_username,
            seller.username     AS seller_username,
            a.auction_id
        FROM Transactions t
        JOIN Auctions   a       ON t.auction_id  = a.auction_id
        JOIN Items      i       ON a.item_id     = i.item_id
        JOIN Categories c       ON i.category_id = c.category_id
        JOIN Users      buyer   ON t.buyer_id    = buyer.user_id
        JOIN Users      seller  ON t.seller_id   = seller.user_id
        ORDER BY t.completed_at DESC
        LIMIT 10
        """
    )

    return render_template(
        "stats.html",
        top_sellers=top_sellers,
        ending_soon=ending_soon,
        category_board=category_board,
        recent_sales=recent_sales,
    )
