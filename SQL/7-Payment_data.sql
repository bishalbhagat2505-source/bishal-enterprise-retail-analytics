
-- =========================================================
-- BISHAL ENTERPRISE
-- BATCH 6: PAYMENT DATA GENERATION
-- Database: smartphone_wholesale_retail_db
-- =========================================================

USE smartphone_wholesale_retail_db;


-- =========================================================
-- STEP 1: SALES - FIRST PAYMENT
-- 80% of sales are paid in one transaction.
-- 20% are paid in two instalments.
-- =========================================================

INSERT INTO payments
(
    sale_id,
    purchase_id,
    payment_date,
    payment_method,
    amount,
    payment_status,
    transaction_reference
)

SELECT
    s.sale_id,
    NULL,

    DATE_ADD(
        DATE(s.sale_date),
        INTERVAL MOD(s.sale_id, 5) DAY
    ),

    CASE MOD(s.sale_id, 5)
        WHEN 0 THEN 'UPI'
        WHEN 1 THEN 'Cash'
        WHEN 2 THEN 'Card'
        WHEN 3 THEN 'Bank Transfer'
        ELSE 'EMI'
    END,

    CASE
        WHEN MOD(s.sale_id, 5) = 0
            THEN ROUND(s.net_amount * 0.60, 2)
        ELSE s.net_amount
    END,

    'Completed',

    CONCAT('SALE-', s.sale_id, '-P1')

FROM sales s

WHERE s.net_amount > 0

AND NOT EXISTS (
    SELECT 1
    FROM payments p
    WHERE p.transaction_reference =
          CONCAT('SALE-', s.sale_id, '-P1')
);


-- =========================================================
-- STEP 2: SALES - SECOND INSTALMENT
-- Remaining 40% for selected sales.
-- =========================================================

INSERT INTO payments
(
    sale_id,
    purchase_id,
    payment_date,
    payment_method,
    amount,
    payment_status,
    transaction_reference
)

SELECT
    s.sale_id,
    NULL,

    DATE_ADD(
        DATE(s.sale_date),
        INTERVAL (MOD(s.sale_id, 5) + 7) DAY
    ),

    CASE MOD(s.sale_id, 4)
        WHEN 0 THEN 'UPI'
        WHEN 1 THEN 'Bank Transfer'
        WHEN 2 THEN 'Card'
        ELSE 'Cash'
    END,

    s.net_amount -
    ROUND(s.net_amount * 0.60, 2),

    'Completed',

    CONCAT('SALE-', s.sale_id, '-P2')

FROM sales s

WHERE MOD(s.sale_id, 5) = 0
AND s.net_amount > 0

AND NOT EXISTS (
    SELECT 1
    FROM payments p
    WHERE p.transaction_reference =
          CONCAT('SALE-', s.sale_id, '-P2')
);


-- =========================================================
-- STEP 3: PURCHASES - FULL PAYMENTS
-- Purchases marked Paid receive full payment.
-- =========================================================

INSERT INTO payments
(
    sale_id,
    purchase_id,
    payment_date,
    payment_method,
    amount,
    payment_status,
    transaction_reference
)

SELECT
    NULL,
    p.purchase_id,

    DATE_ADD(
        p.purchase_date,
        INTERVAL MOD(p.purchase_id, 4) DAY
    ),

    CASE MOD(p.purchase_id, 4)
        WHEN 0 THEN 'Bank Transfer'
        WHEN 1 THEN 'UPI'
        WHEN 2 THEN 'Card'
        ELSE 'Cash'
    END,

    p.total_amount,

    'Completed',

    CONCAT('PURCHASE-', p.purchase_id, '-P1')

FROM purchases p

WHERE p.payment_status = 'Paid'
AND p.total_amount > 0

AND NOT EXISTS (
    SELECT 1
    FROM payments pay
    WHERE pay.transaction_reference =
          CONCAT('PURCHASE-', p.purchase_id, '-P1')
);


-- =========================================================
-- STEP 4: PURCHASES - PARTIAL PAYMENTS
-- Purchases marked Partial receive 50% payment.
-- Remaining amount stays outstanding.
-- =========================================================

INSERT INTO payments
(
    sale_id,
    purchase_id,
    payment_date,
    payment_method,
    amount,
    payment_status,
    transaction_reference
)

SELECT
    NULL,
    p.purchase_id,

    DATE_ADD(
        p.purchase_date,
        INTERVAL MOD(p.purchase_id, 5) DAY
    ),

    CASE MOD(p.purchase_id, 3)
        WHEN 0 THEN 'Bank Transfer'
        WHEN 1 THEN 'UPI'
        ELSE 'Cash'
    END,

    ROUND(p.total_amount * 0.50, 2),

    'Completed',

    CONCAT('PURCHASE-', p.purchase_id, '-P1')

FROM purchases p

WHERE p.payment_status = 'Partial'
AND p.total_amount > 0

AND NOT EXISTS (
    SELECT 1
    FROM payments pay
    WHERE pay.transaction_reference =
          CONCAT('PURCHASE-', p.purchase_id, '-P1')
);


-- =========================================================
-- STEP 5: TOTAL PAYMENT SUMMARY
-- =========================================================

SELECT
    COUNT(*) AS total_payment_records,
    ROUND(SUM(amount), 2) AS total_payment_value,
    COUNT(DISTINCT sale_id) AS sales_with_payments,
    COUNT(DISTINCT purchase_id) AS purchases_with_payments
FROM payments;


-- =========================================================
-- STEP 6: PAYMENT METHOD ANALYSIS
-- =========================================================

SELECT
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_collected

FROM payments

WHERE payment_status = 'Completed'

GROUP BY payment_method

ORDER BY total_collected DESC;


-- =========================================================
-- STEP 7: SALES PAYMENT RECONCILIATION
-- =========================================================

SELECT
    s.sale_id,
    s.total_amount,
    COALESCE(SUM(p.amount), 0) AS amount_paid,

    s.total_amount - COALESCE(SUM(p.amount), 0)
        AS outstanding_amount

FROM sales s

LEFT JOIN payments p
    ON s.sale_id = p.sale_id
    AND p.payment_status = 'Completed'

GROUP BY
    s.sale_id,
    s.total_amount

HAVING outstanding_amount <> 0;


-- =========================================================
-- STEP 8: PURCHASE PAYMENT RECONCILIATION
-- =========================================================

SELECT
    pu.purchase_id,
    pu.total_amount,
    COALESCE(SUM(p.amount), 0) AS amount_paid,

    pu.total_amount - COALESCE(SUM(p.amount), 0)
        AS outstanding_amount

FROM purchases pu

LEFT JOIN payments p
    ON pu.purchase_id = p.purchase_id
    AND p.payment_status = 'Completed'

GROUP BY
    pu.purchase_id,
    pu.total_amount

HAVING outstanding_amount <> 0;


-- =========================================================
-- STEP 9: MONTHLY PAYMENT COLLECTION
-- =========================================================

SELECT
    MONTH(payment_date) AS month_number,
    MONTHNAME(payment_date) AS month_name,
    ROUND(SUM(amount), 2) AS total_collected

FROM payments

WHERE payment_status = 'Completed'

GROUP BY
    MONTH(payment_date),
    MONTHNAME(payment_date)

ORDER BY month_number;
