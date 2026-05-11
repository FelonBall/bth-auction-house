-- =============================================================
--  BTH Auction House  --  DV1663 Final Project
--  File: 02_routines.sql
--  Purpose: Triggers, stored procedures, and functions.
--
--  Course-requirement coverage:
--    - 2 triggers   (trg_bid_before_insert, trg_bid_after_insert)
--    - 2 procedures (sp_close_expired_auctions, sp_end_auction_now)
--    - 2 functions  (fn_get_bid_count, fn_is_auction_active)
-- =============================================================

-- Drop existing routines so this file is re-runnable.
DROP TRIGGER   IF EXISTS trg_bid_before_insert;
DROP TRIGGER   IF EXISTS trg_bid_after_insert;
DROP PROCEDURE IF EXISTS sp_close_expired_auctions;
DROP PROCEDURE IF EXISTS sp_end_auction_now;
DROP FUNCTION  IF EXISTS fn_get_bid_count;
DROP FUNCTION  IF EXISTS fn_is_auction_active;

-- -------------------------------------------------------------
--  TRIGGER 1 of 2: validate every incoming bid.
--  Centralises all business rules so the application can never
--  bypass them, even with raw SQL access.
-- -------------------------------------------------------------
DELIMITER $$

CREATE TRIGGER trg_bid_before_insert
BEFORE INSERT ON Bids
FOR EACH ROW
BEGIN
    DECLARE v_status        VARCHAR(20);
    DECLARE v_end_time      DATETIME;
    DECLARE v_current_price INT;
    DECLARE v_seller_id     INT;

    SELECT a.status, a.end_time, a.current_price, i.seller_id
      INTO v_status, v_end_time, v_current_price, v_seller_id
      FROM Auctions a
      JOIN Items    i ON a.item_id = i.item_id
     WHERE a.auction_id = NEW.auction_id;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction does not exist';
    END IF;

    IF v_status <> 'active' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction is not active';
    END IF;

    IF v_end_time <= NOW() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction has already ended';
    END IF;

    IF v_seller_id = NEW.bidder_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Sellers cannot bid on their own items';
    END IF;

    IF NEW.amount <= v_current_price THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Bid amount must be greater than current price';
    END IF;
END$$

-- -------------------------------------------------------------
--  TRIGGER 2 of 2: keep the denormalised "current_price" and
--  "high_bidder_id" on Auctions in sync with the latest valid
--  bid. Doing this in the DB rather than the app guarantees
--  consistency under concurrent writes.
-- -------------------------------------------------------------
CREATE TRIGGER trg_bid_after_insert
AFTER INSERT ON Bids
FOR EACH ROW
BEGIN
    UPDATE Auctions
       SET current_price  = NEW.amount,
           high_bidder_id = NEW.bidder_id
     WHERE auction_id = NEW.auction_id;
END$$

-- -------------------------------------------------------------
--  PROCEDURE 1 of 2: close every auction whose end_time has
--  passed. Auctions with a winning bidder get a Transactions
--  row; auctions with no bidders are simply marked closed.
--  Intended to be invoked periodically (e.g. before each page
--  load that lists auctions) or via a scheduler.
-- -------------------------------------------------------------
CREATE PROCEDURE sp_close_expired_auctions()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- 1. Create transactions for expired auctions that have a winner.
    INSERT INTO Transactions (auction_id, buyer_id, seller_id, sale_price)
    SELECT a.auction_id,
           a.high_bidder_id,
           i.seller_id,
           a.current_price
      FROM Auctions a
      JOIN Items    i ON a.item_id = i.item_id
     WHERE a.status         = 'active'
       AND a.end_time      <= NOW()
       AND a.high_bidder_id IS NOT NULL;

    -- 2. Mark all expired active auctions as closed (with or without bids).
    UPDATE Auctions
       SET status = 'closed'
     WHERE status   = 'active'
       AND end_time <= NOW();

    COMMIT;
END$$

-- -------------------------------------------------------------
--  EXTRA PROCEDURE: end a single auction immediately.
--  Used by the seller "End auction now" button on the auction
--  detail page. Performs permission and state checks, creates
--  the transaction inline if there is a winning bidder, and
--  flips the auction's status to 'closed'.
-- -------------------------------------------------------------
CREATE PROCEDURE sp_end_auction_now(
    IN p_auction_id INT,
    IN p_user_id    INT
)
BEGIN
    DECLARE v_seller_id     INT;
    DECLARE v_status        VARCHAR(20);
    DECLARE v_high_bidder   INT;
    DECLARE v_current_price INT;

    SELECT i.seller_id, a.status, a.high_bidder_id, a.current_price
      INTO v_seller_id, v_status, v_high_bidder, v_current_price
      FROM Auctions a
      JOIN Items    i ON a.item_id = i.item_id
     WHERE a.auction_id = p_auction_id;

    IF v_seller_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction does not exist';
    END IF;

    IF v_seller_id <> p_user_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only the seller can end this auction';
    END IF;

    IF v_status <> 'active' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction is already closed';
    END IF;

    IF v_high_bidder IS NOT NULL THEN
        INSERT INTO Transactions (auction_id, buyer_id, seller_id, sale_price)
        VALUES (p_auction_id, v_high_bidder, v_seller_id, v_current_price);
    END IF;

    UPDATE Auctions
       SET status   = 'closed',
           end_time = NOW() + INTERVAL 1 SECOND
     WHERE auction_id = p_auction_id;
END$$

-- -------------------------------------------------------------
--  FUNCTION 1 of 2: bid count for a single auction. Useful as
--  a reusable building block in SELECT lists.
-- -------------------------------------------------------------
CREATE FUNCTION fn_get_bid_count(p_auction_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
      FROM Bids
     WHERE auction_id = p_auction_id;
    RETURN v_count;
END$$

-- -------------------------------------------------------------
--  FUNCTION 2 of 2: business definition of "active". Returns
--  TRUE only if the auction's status is 'active' AND its
--  end_time is still in the future.
-- -------------------------------------------------------------
CREATE FUNCTION fn_is_auction_active(p_auction_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_status   VARCHAR(20);
    DECLARE v_end_time DATETIME;

    SELECT status, end_time
      INTO v_status, v_end_time
      FROM Auctions
     WHERE auction_id = p_auction_id;

    IF v_status IS NULL THEN
        RETURN FALSE;
    END IF;

    RETURN (v_status = 'active' AND v_end_time > NOW());
END$$

DELIMITER ;
