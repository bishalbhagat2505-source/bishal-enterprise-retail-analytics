USE smartphone_wholesale_retail_db;
-- We are making small adjustments that will help us as a buffer for inventory management 


UPDATE inventory
SET opening_stock =
    GREATEST(110 - stock_purchased, opening_stock);

UPDATE inventory
SET current_stock =
    opening_stock + stock_purchased;



-- =========================================================
-- BISHAL ENTERPRISE
-- BATCH 5: SALES DATA GENERATION
-- Target: 3,500 Sales + 7,000 Sale Items
-- Period: January - December 2025
-- =========================================================

USE smartphone_wholesale_retail_db;

SET SESSION cte_max_recursion_depth = 4000;


-- =========================================================
-- STEP 1: CREATE 3,500 SALES TRANSACTIONS
-- =========================================================

INSERT INTO sales
(
    customer_id,
    employee_id,
    sale_date,
    transaction_type,
    total_amount,
    net_amount
)

WITH RECURSIVE sale_numbers AS
(
    SELECT 1 AS sale_no

    UNION ALL

    SELECT sale_no + 1
    FROM sale_numbers
    WHERE sale_no < 3500
),

customer_list AS
(
    SELECT
        customer_id,
        ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_no
    FROM customers
),

employee_list AS
(
    SELECT
        employee_id,
        ROW_NUMBER() OVER (ORDER BY employee_id) AS employee_no
    FROM employees
)

SELECT
    c.customer_id,
    e.employee_id,

    DATE_ADD(
        '2025-01-01',
        INTERVAL MOD(sn.sale_no * 17, 365) DAY
    ),

    'Mixed',

    0,
    0

FROM sale_numbers sn

JOIN customer_list c
    ON c.customer_no =
       MOD(sn.sale_no * 13 - 1,
           (SELECT COUNT(*) FROM customers)) + 1

JOIN employee_list e
    ON e.employee_no =
       MOD(sn.sale_no * 3 - 1,
           (SELECT COUNT(*) FROM employees)) + 1

WHERE NOT EXISTS (
    SELECT 1 FROM sales
);


-- =========================================================
-- STEP 2: CREATE 7,000 SALE ITEM RECORDS
-- Two different products per transaction
-- One unit per product line
-- =========================================================

INSERT INTO sale_items
(
    sale_id,
    product_id,
    quantity,
    unit_price,
    subtotal
)

WITH RECURSIVE sale_numbers AS
(
    SELECT 1 AS sale_no

    UNION ALL

    SELECT sale_no + 1
    FROM sale_numbers
    WHERE sale_no < 3500
),

sale_list AS
(
    SELECT
        sale_id,
        ROW_NUMBER() OVER (ORDER BY sale_id) AS sale_no
    FROM sales
),

product_list AS
(
    SELECT
        product_id,
        selling_price,
        ROW_NUMBER() OVER (ORDER BY product_id) AS product_no
    FROM products
),

item_slots AS
(
    SELECT 1 AS item_no

    UNION ALL

    SELECT 2
)

SELECT
    sl.sale_id,
    p.product_id,
    1 AS quantity,
    p.selling_price AS unit_price,
    p.selling_price AS subtotal

FROM sale_numbers sn

CROSS JOIN item_slots its

JOIN sale_list sl
    ON sl.sale_no = sn.sale_no

JOIN product_list p
    ON p.product_no =
       MOD(
           sn.sale_no * 13 + its.item_no * 17 - 1,
           (SELECT COUNT(*) FROM products)
       ) + 1

WHERE NOT EXISTS (
    SELECT 1 FROM sale_items
);


-- =========================================================
-- STEP 3: UPDATE SALES TOTALS
-- Calculate transaction amounts from sale items
-- =========================================================

UPDATE sales s

JOIN
(
    SELECT
        sale_id,
        SUM(subtotal) AS calculated_total
    FROM sale_items
    GROUP BY sale_id
) si

ON s.sale_id = si.sale_id

SET
    s.total_amount = si.calculated_total,
    s.net_amount = si.calculated_total;


-- =========================================================
-- STEP 4: CLASSIFY TRANSACTION TYPES
-- =========================================================

UPDATE sales s

JOIN
(
    SELECT
        si.sale_id,

        CASE
            WHEN COUNT(DISTINCT p.category) > 1
                THEN 'Mixed'

            WHEN MAX(p.category) = 'Smartphone'
                THEN 'Smartphone'

            ELSE 'Accessory'
        END AS calculated_type

    FROM sale_items si

    JOIN products p
        ON si.product_id = p.product_id

    GROUP BY si.sale_id
) transaction_summary

ON s.sale_id = transaction_summary.sale_id

SET s.transaction_type = transaction_summary.calculated_type;


-- =========================================================
-- STEP 5: SALES SUMMARY
-- =========================================================

SELECT
    COUNT(*) AS total_sales,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS average_transaction_value
FROM sales;


-- =========================================================
-- STEP 6: SALE ITEM SUMMARY
-- =========================================================

SELECT
    COUNT(*) AS total_sale_items,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(subtotal), 2) AS total_item_revenue
FROM sale_items;


-- =========================================================
-- STEP 7: MONTHLY SALES ANALYSIS
-- =========================================================

SELECT
    MONTH(sale_date) AS month_number,
    MONTHNAME(sale_date) AS month_name,
    COUNT(*) AS total_transactions,
    ROUND(SUM(net_amount), 2) AS monthly_revenue

FROM sales

GROUP BY
    MONTH(sale_date),
    MONTHNAME(sale_date)

ORDER BY month_number;


-- =========================================================
-- STEP 8: EMPLOYEE-WISE SALES
-- =========================================================

SELECT
    e.employee_name,
    e.employment_status,
    COUNT(s.sale_id) AS transactions_handled,
    ROUND(SUM(s.net_amount), 2) AS revenue_generated

FROM employees e

LEFT JOIN sales s
    ON e.employee_id = s.employee_id

GROUP BY
    e.employee_id,
    e.employee_name,
    e.employment_status

ORDER BY revenue_generated DESC;


-- =========================================================
-- STEP 9: CUSTOMER TYPE SALES ANALYSIS
-- =========================================================

SELECT
    c.customer_type,
    COUNT(s.sale_id) AS total_transactions,
    ROUND(SUM(s.net_amount), 2) AS total_revenue

FROM customers c

JOIN sales s
    ON c.customer_id = s.customer_id

GROUP BY c.customer_type;
