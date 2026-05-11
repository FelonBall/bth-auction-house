-- =============================================================
--  BTH Auction House  -  DV1663 Final Project
--  File: 01_schema.sql
--  Purpose: Create all tables, keys, constraints, and indexes.
--  Target: MySQL 8 (utf8mb4)
-- =============================================================

-- Drop in reverse-dependency order so re-runs are idempotent.
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Watchlist;
DROP TABLE IF EXISTS Bids;
DROP TABLE IF EXISTS Auctions;
DROP TABLE IF EXISTS Items;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Users;

-- -------------------------------------------------------------
--  Users
-- -------------------------------------------------------------
CREATE TABLE Users (
    user_id        INT          NOT NULL AUTO_INCREMENT,
    username       VARCHAR(50)  NOT NULL,
    email          VARCHAR(255) NOT NULL,
    password_hash  VARCHAR(255) NOT NULL,
    created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_users_username (username),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Categories  (self-referencing for sub-categories)
-- -------------------------------------------------------------
CREATE TABLE Categories (
    category_id  INT          NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL,
    parent_id    INT          NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY uq_categories_name (name),
    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_id) REFERENCES Categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Items
-- -------------------------------------------------------------
CREATE TABLE Items (
    item_id         INT           NOT NULL AUTO_INCREMENT,
    seller_id       INT           NOT NULL,
    category_id     INT           NOT NULL,
    title           VARCHAR(200)  NOT NULL,
    description     TEXT          NULL,
    item_condition  ENUM('new','like_new','good','fair','poor') NOT NULL,
    created_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (item_id),
    KEY ix_items_seller (seller_id),
    KEY ix_items_category (category_id),
    CONSTRAINT fk_items_seller
        FOREIGN KEY (seller_id) REFERENCES Users(user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_items_category
        FOREIGN KEY (category_id) REFERENCES Categories(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Auctions  (one auction per item)
-- -------------------------------------------------------------
CREATE TABLE Auctions (
    auction_id      INT             NOT NULL AUTO_INCREMENT,
    item_id         INT             NOT NULL,
    -- Prices are stored as whole SEK (kronor). Enforced at column level.
    start_price     INT             NOT NULL,
    current_price   INT             NOT NULL,
    start_time      DATETIME        NOT NULL,
    end_time        DATETIME        NOT NULL,
    status          ENUM('active','closed','cancelled') NOT NULL DEFAULT 'active',
    high_bidder_id  INT             NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (auction_id),
    UNIQUE KEY uq_auctions_item (item_id),
    KEY ix_auctions_status_endtime (status, end_time),
    KEY ix_auctions_high_bidder (high_bidder_id),
    CONSTRAINT fk_auctions_item
        FOREIGN KEY (item_id) REFERENCES Items(item_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_auctions_high_bidder
        FOREIGN KEY (high_bidder_id) REFERENCES Users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT chk_auctions_times CHECK (end_time > start_time),
    CONSTRAINT chk_auctions_prices CHECK (start_price > 0 AND current_price >= start_price)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Bids
-- -------------------------------------------------------------
CREATE TABLE Bids (
    bid_id      INT           NOT NULL AUTO_INCREMENT,
    auction_id  INT           NOT NULL,
    bidder_id   INT           NOT NULL,
    amount      INT           NOT NULL,
    placed_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (bid_id),
    KEY ix_bids_auction (auction_id),
    KEY ix_bids_bidder (bidder_id),
    KEY ix_bids_auction_amount (auction_id, amount),
    CONSTRAINT fk_bids_auction
        FOREIGN KEY (auction_id) REFERENCES Auctions(auction_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_bids_bidder
        FOREIGN KEY (bidder_id) REFERENCES Users(user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_bids_amount CHECK (amount > 0)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Watchlist  (many-to-many: user follows auction)
-- -------------------------------------------------------------
CREATE TABLE Watchlist (
    user_id     INT      NOT NULL,
    auction_id  INT      NOT NULL,
    added_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, auction_id),
    KEY ix_watchlist_auction (auction_id),
    CONSTRAINT fk_watchlist_user
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_watchlist_auction
        FOREIGN KEY (auction_id) REFERENCES Auctions(auction_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
--  Transactions  (one per closed auction with a winner)
-- -------------------------------------------------------------
CREATE TABLE Transactions (
    transaction_id  INT           NOT NULL AUTO_INCREMENT,
    auction_id      INT           NOT NULL,
    buyer_id        INT           NOT NULL,
    seller_id       INT           NOT NULL,
    sale_price      INT           NOT NULL,
    completed_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (transaction_id),
    UNIQUE KEY uq_transactions_auction (auction_id),
    KEY ix_transactions_buyer (buyer_id),
    KEY ix_transactions_seller (seller_id),
    KEY ix_transactions_completed (completed_at),
    CONSTRAINT fk_transactions_auction
        FOREIGN KEY (auction_id) REFERENCES Auctions(auction_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    -- NOTE: ON UPDATE NO ACTION (instead of CASCADE) is required because
    -- MySQL 8 forbids a CHECK constraint on a column that is also part of
    -- an FK with a referential action. user_id is AUTO_INCREMENT and never
    -- updated in practice, so this restriction has no functional impact.
    CONSTRAINT fk_transactions_buyer
        FOREIGN KEY (buyer_id) REFERENCES Users(user_id)
        ON DELETE RESTRICT
        ON UPDATE NO ACTION,
    CONSTRAINT fk_transactions_seller
        FOREIGN KEY (seller_id) REFERENCES Users(user_id)
        ON DELETE RESTRICT
        ON UPDATE NO ACTION,
    CONSTRAINT chk_transactions_parties CHECK (buyer_id <> seller_id),
    CONSTRAINT chk_transactions_price CHECK (sale_price > 0)
) ENGINE=InnoDB;
