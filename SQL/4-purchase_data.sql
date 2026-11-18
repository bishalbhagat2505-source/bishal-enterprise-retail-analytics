
-- =========================================================
-- BISHAL ENTERPRISE
-- BATCH 3: PURCHASE TRANSACTIONS
-- Target: 200 Purchases + 600 Purchase Items
-- Period: January - December 2025
-- =========================================================

USE smartphone_wholesale_retail_db;

SET SESSION cte_max_recursion_depth = 3000;


-- =========================================================
-- STEP 1: GENERATE 200 PURCHASE TRANSACTIONS
-- =========================================================

INSERT INTO purchases
(
    supplier_id,
    employee_id,
    purchase_date,
    total_amount,
    payment_status
)

WITH RECURSIVE purchase_numbers AS
(
    SELECT 1 AS purchase_no

    UNION ALL

    SELECT purchase_no + 1
    FROM purchase_numbers
    WHERE purchase_no < 200
),

supplier_list AS
(
    SELECT
        supplier_id,
        ROW_NUMBER() OVER (ORDER BY supplier_id) AS supplier_no
    FROM suppliers
),

employee_list AS
(
    SELECT
        employee_id,
        ROW_NUMBER() OVER (ORDER BY employee_id) AS employee_no
    FROM employees
)

SELECT
    s.supplier_id,
    e.employee_id,

    DATE_ADD(
        '2025-01-01',
        INTERVAL MOD(p.purchase_no * 37, 365) DAY
    ),

    0,

    CASE
        WHEN MOD(p.purchase_no, 10) < 6 THEN 'Paid'
        WHEN MOD(p.purchase_no, 10) < 9 THEN 'Partial'
        ELSE 'Unpaid'
    END

FROM purchase_numbers p

JOIN supplier_list s
    ON s.supplier_no =
       MOD(p.purchase_no - 1, (SELECT COUNT(*) FROM suppliers)) + 1

JOIN employee_list e
    ON e.employee_no =
       MOD(p.purchase_no * 3 - 1, (SELECT COUNT(*) FROM employees)) + 1

WHERE NOT EXISTS (
    SELECT 1 FROM purchases
);


-- =========================================================
-- STEP 2: GENERATE 600 PURCHASE ITEM RECORDS
-- Three products per purchase
-- =========================================================

INSERT INTO purchase_items
(
    purchase_id,
    product_id,
    quantity,
    unit_cost,
    subtotal
)

WITH RECURSIVE purchase_numbers AS
(
    SELECT 1 AS purchase_no

    UNION ALL

    SELECT purchase_no + 1
    FROM purchase_numbers
    WHERE purchase_no < 200
),

product_list AS
(
    SELECT
        product_id,
        purchase_price,
        ROW_NUMBER() OVER (ORDER BY product_id) AS product_no
    FROM products
),

purchase_list AS
(
    SELECT
        purchase_id,
        ROW_NUMBER() OVER (
            ORDER BY purchase_date, purchase_id
        ) AS purchase_no
    FROM purchases
),

item_slots AS
(
    SELECT 1 AS item_no
    UNION ALL SELECT 2
    UNION ALL SELECT 3
)

SELECT
    pl.purchase_id,
    pr.product_id,

    2 + MOD(
        pn.purchase_no * 7 + slots.item_no * 3,
        7
    ) AS quantity,

    pr.purchase_price,

    (
        2 + MOD(
            pn.purchase_no * 7 + slots.item_no * 3,
            7
        )
    ) * pr.purchase_price AS subtotal

FROM purchase_numbers pn

CROSS JOIN item_slots slots

JOIN purchase_list pl
    ON pl.purchase_no = pn.purchase_no

JOIN product_list pr
    ON pr.product_no =
       MOD(
           pn.purchase_no * 7 + slots.item_no * 13 - 1,
           (SELECT COUNT(*) FROM products)
       ) + 1

WHERE NOT EXISTS (
    SELECT 1 FROM purchase_items
);


-- =========================================================
-- STEP 3: UPDATE PURCHASE TOTALS
-- Calculate total from purchase item subtotals.
-- =========================================================

UPDATE purchases p

JOIN (
    SELECT
        purchase_id,
        SUM(subtotal) AS calculated_total
    FROM purchase_items
    GROUP BY purchase_id
) pi

ON p.purchase_id = pi.purchase_id

SET p.total_amount = pi.calculated_total;


-- =========================================================
-- STEP 4: VERIFY PURCHASE DATA
-- =========================================================

SELECT
    COUNT(*) AS total_purchases,
    ROUND(SUM(total_amount), 2) AS total_purchase_value,
    ROUND(AVG(total_amount), 2) AS average_purchase_value
FROM purchases;


SELECT
    COUNT(*) AS total_purchase_items,
    SUM(quantity) AS total_units_purchased,
    ROUND(SUM(subtotal), 2) AS total_item_value
FROM purchase_items;


-- =========================================================
-- STEP 5: SUPPLIER-WISE PURCHASE ANALYSIS
-- =========================================================

SELECT
    s.supplier_name,
    COUNT(p.purchase_id) AS total_purchases,
    ROUND(SUM(p.total_amount), 2) AS total_purchase_value

FROM suppliers s

LEFT JOIN purchases p
    ON s.supplier_id = p.supplier_id

GROUP BY
    s.supplier_id,
    s.supplier_name

ORDER BY total_purchase_value DESC;


-- =========================================================
-- STEP 6: PAYMENT STATUS ANALYSIS
-- =========================================================

SELECT
    payment_status,
    COUNT(*) AS total_transactions,
    ROUND(SUM(total_amount), 2) AS purchase_value

FROM purchases

GROUP BY payment_status;
