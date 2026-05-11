-- =============================================================
--  BTH Auction House  --  DV1663 Final Project
--  File: 04_documented_queries.sql
--  Purpose: The six queries documented and motivated in the
--           report. Each is also used by the Flask app.
--
--  Coverage summary:
--    Q1 multirelation, JOIN (3 tables), uses fn_get_bid_count()
--    Q2 multirelation, JOIN, GROUP BY, SUM, ORDER BY  (top sellers)
--    Q3 multirelation, JOIN/LEFT JOIN (5 tables)      (bid history)
--    Q4 JOIN, uses fn_is_auction_active()             (ending soon)
--    Q5 multirelation, JOIN (4 tables), GROUP BY, AVG (categories)
--    Q6 multirelation, JOIN (4 tables)                (watchlist)
-- =============================================================

-- -------------------------------------------------------------
--  Q1: Browse active auctions, optionally filtered by category.
--      Joins Auctions x Items x Categories x Users (seller).
--      bid_count uses a derived-table GROUP BY instead of a
--      per-row scalar function call, keeping the query set-based.
-- -------------------------------------------------------------
-- Parameters: :category_id (nullable)
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
    FROM Bids
    GROUP BY auction_id
) bc ON bc.auction_id = a.auction_id
WHERE a.status = 'active'
  AND a.end_time > NOW()
  AND (:category_id IS NULL OR c.category_id = :category_id)
ORDER BY a.end_time ASC;


-- -------------------------------------------------------------
--  Q2: Top 5 sellers by total sale value over the last 30 days.
--      Aggregation + grouping over Transactions x Users.
-- -------------------------------------------------------------
SELECT
    u.user_id,
    u.username,
    COUNT(*)        AS sales_count,
    SUM(t.sale_price) AS total_revenue,
    AVG(t.sale_price) AS avg_sale_price
FROM Transactions t
JOIN Users u ON t.seller_id = u.user_id
WHERE t.completed_at >= (NOW() - INTERVAL 30 DAY)
GROUP BY u.user_id, u.username
ORDER BY total_revenue DESC
LIMIT 5;


-- -------------------------------------------------------------
--  Q3: A given user's bidding history with win/loss outcome.
--      LEFT JOIN to Transactions reveals whether the user won.
--      Touches 5 tables: Bids, Auctions, Items, Users (seller),
--      Transactions.
-- -------------------------------------------------------------
-- Parameter: :user_id
SELECT
    b.bid_id,
    b.amount,
    b.placed_at,
    a.auction_id,
    i.title,
    seller.username        AS seller_username,
    a.status               AS auction_status,
    a.end_time,
    a.current_price        AS current_high_bid,
    CASE
        WHEN t.buyer_id = :user_id THEN 'won'
        WHEN a.status   = 'closed' THEN 'lost'
        WHEN a.high_bidder_id = :user_id THEN 'leading'
        ELSE 'outbid'
    END AS outcome
FROM Bids b
JOIN Auctions     a      ON b.auction_id = a.auction_id
JOIN Items        i      ON a.item_id    = i.item_id
JOIN Users        seller ON i.seller_id  = seller.user_id
LEFT JOIN Transactions t ON t.auction_id = a.auction_id
WHERE b.bidder_id = :user_id
ORDER BY b.placed_at DESC;


-- -------------------------------------------------------------
--  Q4: Active auctions ending in the next 24 hours, ranked by
--      number of bids. Inline WHERE conditions allow MySQL to use
--      the composite index ix_auctions_status_endtime(status, end_time).
--      fn_get_bid_count() is kept in the SELECT as a showcase; in
--      the app a LEFT JOIN subquery replaces it for bulk performance.
-- -------------------------------------------------------------
SELECT
    a.auction_id,
    i.title,
    a.current_price,
    a.end_time,
    TIMESTAMPDIFF(MINUTE, NOW(), a.end_time) AS minutes_remaining,
    fn_get_bid_count(a.auction_id)            AS bid_count
FROM Auctions a
JOIN Items i ON a.item_id = i.item_id
WHERE a.status   = 'active'
  AND a.end_time > NOW()
  AND a.end_time <= (NOW() + INTERVAL 24 HOUR)
ORDER BY bid_count DESC, a.end_time ASC;


-- -------------------------------------------------------------
--  Q5: Category leaderboard: average sale price and item count
--      per top-level category. Joins 4 tables, uses GROUP BY,
--      COUNT, AVG, MIN, MAX.
-- -------------------------------------------------------------
SELECT
    c.category_id,
    c.name                   AS category_name,
    COUNT(t.transaction_id)  AS sales_count,
    AVG(t.sale_price)        AS avg_sale_price,
    MIN(t.sale_price)        AS min_sale_price,
    MAX(t.sale_price)        AS max_sale_price
FROM Categories   c
JOIN Items        i ON i.category_id = c.category_id
JOIN Auctions     a ON a.item_id     = i.item_id
JOIN Transactions t ON t.auction_id  = a.auction_id
GROUP BY c.category_id, c.name
HAVING sales_count > 0
ORDER BY avg_sale_price DESC;


-- -------------------------------------------------------------
--  Q6: Logged-in user's watchlist with current standings.
--      Joins 4 tables. Shows whether the user is currently the
--      high bidder on each watched auction.
--      fn_is_auction_active() is kept in the SELECT list (not
--      WHERE) so it does not prevent index use.
-- -------------------------------------------------------------
-- Parameter: :user_id
SELECT
    w.added_at,
    a.auction_id,
    i.title,
    seller.username                    AS seller_username,
    a.current_price,
    a.end_time,
    a.status,
    (a.high_bidder_id = :user_id)      AS is_high_bidder,
    COALESCE(bc.bid_count, 0)          AS bid_count,
    fn_is_auction_active(a.auction_id) AS is_active
FROM Watchlist w
JOIN Auctions a      ON w.auction_id = a.auction_id
JOIN Items    i      ON a.item_id    = i.item_id
JOIN Users    seller ON i.seller_id  = seller.user_id
LEFT JOIN (
    SELECT auction_id, COUNT(*) AS bid_count
    FROM Bids
    GROUP BY auction_id
) bc ON bc.auction_id = a.auction_id
WHERE w.user_id = :user_id
ORDER BY a.end_time ASC;
