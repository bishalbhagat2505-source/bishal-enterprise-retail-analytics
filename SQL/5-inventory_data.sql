
-- =========================================================
-- BISHAL ENTERPRISE
-- BATCH 4: INVENTORY GENERATION
-- Database: smartphone_wholesale_retail_db
-- =========================================================

USE smartphone_wholesale_retail_db;


-- STEP 1: GENERATE OPENING STOCK AND PURCHASED STOCK

INSERT INTO inventory
(
    product_id,
    opening_stock,
    stock_purchased,
    stock_sold,
    current_stock
)

SELECT
    p.product_id,

    -- Opening stock varies by product category
    CASE
        WHEN p.category = 'Smartphone'
            THEN 50 + MOD(p.product_id * 7, 41)
        ELSE 100 + MOD(p.product_id * 11, 61)
    END AS opening_stock,

    -- Calculate purchased quantity from purchase_items
    COALESCE(pi.total_purchased, 0) AS stock_purchased,

    -- No sales have been generated yet
    0 AS stock_sold,

    -- Initial stock = opening stock + purchased stock
    CASE
        WHEN p.category = 'Smartphone'
            THEN 50 + MOD(p.product_id * 7, 41)
        ELSE 100 + MOD(p.product_id * 11, 61)
    END
    + COALESCE(pi.total_purchased, 0) AS current_stock

FROM products p

LEFT JOIN
(
    SELECT
        product_id,
        SUM(quantity) AS total_purchased
    FROM purchase_items
    GROUP BY product_id
) pi

ON p.product_id = pi.product_id

WHERE NOT EXISTS
(
    SELECT 1
    FROM inventory i
    WHERE i.product_id = p.product_id
);


-- =========================================================
-- STEP 2: VERIFY INVENTORY RECORDS
-- =========================================================

SELECT
    COUNT(*) AS total_inventory_records,
    SUM(opening_stock) AS total_opening_stock,
    SUM(stock_purchased) AS total_stock_purchased,
    SUM(stock_sold) AS total_stock_sold,
    SUM(current_stock) AS total_current_stock

FROM inventory;


-- =========================================================
-- STEP 3: PRODUCT-WISE INVENTORY REPORT
-- =========================================================

SELECT
    p.product_name,
    p.category,
    p.product_status,
    i.opening_stock,
    i.stock_purchased,
    i.stock_sold,
    i.current_stock

FROM inventory i

INNER JOIN products p
    ON i.product_id = p.product_id

ORDER BY i.current_stock DESC;


-- =========================================================
-- STEP 4: INVENTORY VALUATION
-- =========================================================

SELECT

    ROUND(
        SUM(i.current_stock * p.purchase_price),
        2
    ) AS total_inventory_cost_value,

    ROUND(
        SUM(i.current_stock * p.selling_price),
        2
    ) AS potential_inventory_sales_value

FROM inventory i

INNER JOIN products p
    ON i.product_id = p.product_id;


-- =========================================================
-- STEP 5: LOW STOCK ANALYSIS
-- =========================================================

SELECT
    p.product_name,
    i.current_stock,

    CASE
        WHEN i.current_stock = 0 THEN 'Out of Stock'
        WHEN i.current_stock <= 10 THEN 'Critical Stock'
        WHEN i.current_stock <= 25 THEN 'Low Stock'
        ELSE 'Healthy Stock'
    END AS stock_status

FROM inventory i

INNER JOIN products p
    ON i.product_id = p.product_id

ORDER BY i.current_stock ASC;


-- =========================================================
-- STEP 6: INVENTORY RECONCILIATION
-- =========================================================

SELECT
    product_id,
    opening_stock,
    stock_purchased,
    stock_sold,
    current_stock,

    opening_stock + stock_purchased - stock_sold
        AS expected_stock

FROM inventory

WHERE current_stock <>
      opening_stock + stock_purchased - stock_sold;
