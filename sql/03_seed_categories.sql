-- =============================================================
--  BTH Auction House  --  DV1663 Final Project
--  File: 03_seed_categories.sql
--  Purpose: Insert a curated category tree.
-- =============================================================

INSERT INTO Categories (name, parent_id) VALUES
    ('Electronics',        NULL),
    ('Collectibles',       NULL),
    ('Fashion',            NULL),
    ('Home & Garden',      NULL),
    ('Sports & Outdoors',  NULL),
    ('Vehicles',           NULL),
    ('Art',                NULL);

-- Sub-categories: INSERT...SELECT avoids the MySQL restriction on
-- referencing the same table in INSERT...VALUES subqueries.
INSERT INTO Categories (name, parent_id)
SELECT 'Phones',        category_id FROM Categories WHERE name = 'Electronics'
UNION ALL
SELECT 'Laptops',       category_id FROM Categories WHERE name = 'Electronics'
UNION ALL
SELECT 'Cameras',       category_id FROM Categories WHERE name = 'Electronics'
UNION ALL
SELECT 'Coins',         category_id FROM Categories WHERE name = 'Collectibles'
UNION ALL
SELECT 'Trading Cards', category_id FROM Categories WHERE name = 'Collectibles'
UNION ALL
SELECT 'Watches',       category_id FROM Categories WHERE name = 'Fashion'
UNION ALL
SELECT 'Sneakers',      category_id FROM Categories WHERE name = 'Fashion'
UNION ALL
SELECT 'Furniture',     category_id FROM Categories WHERE name = 'Home & Garden'
UNION ALL
SELECT 'Bicycles',      category_id FROM Categories WHERE name = 'Sports & Outdoors'
UNION ALL
SELECT 'Cars',          category_id FROM Categories WHERE name = 'Vehicles'
UNION ALL
SELECT 'Paintings',     category_id FROM Categories WHERE name = 'Art';
