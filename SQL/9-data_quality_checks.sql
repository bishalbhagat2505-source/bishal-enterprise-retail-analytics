-- We would be checking the data integrity and data validness




USE smartphone_wholesale_retail_db;

SHOW TABLES;


SELECT 'customers' AS table_name, COUNT(*) AS total_records FROM customers
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'brands', COUNT(*) FROM brands
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'purchases', COUNT(*) FROM purchases
UNION ALL
SELECT 'purchase_items', COUNT(*) FROM purchase_items
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'sales', COUNT(*) FROM sales
UNION ALL
SELECT 'sale_items', COUNT(*) FROM sale_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'repairs', COUNT(*) FROM repairs
UNION ALL
SELECT 'customer_feedback', COUNT(*) FROM customer_feedback;



-- check duplicate primary keys

SELECT customer_id, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT brand_id, COUNT(*) AS duplicate_count
FROM brands
GROUP BY brand_id
HAVING COUNT(*) > 1;

SELECT feedback_id,COUNT(*) AS duplicate_count
FROM customer_feedback
GROUP BY feedback_id
HAVING COUNT(*) > 1;

SELECT employee_id, COUNT(*) AS duplicate_count
FROM employees
GROUP BY employee_id
HAVING COUNT(*) > 1;

SELECT inventory_id, COUNT(*) AS duplicate_count
FROM inventory
GROUP BY inventory_id
HAVING COUNT(*) > 1;

SELECT payment_id, COUNT(*) AS duplicate_count
FROM payments
GROUP BY payment_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT purchase_item_id, COUNT(*) AS duplicate_count
FROM purchase_items
GROUP BY purchase_item_id
HAVING COUNT(*) > 1;

SELECT purchase_id, COUNT(*) AS duplicate_count
FROM purchases
GROUP BY purchase_id
HAVING COUNT(*) > 1;

SELECT repair_id, COUNT(*) AS duplicate_count
FROM repairs
GROUP BY repair_id
HAVING COUNT(*) > 1;

SELECT sale_item_id, COUNT(*) AS duplicate_count
FROM sale_items
GROUP BY sale_item_id
HAVING COUNT(*) > 1;

SELECT sale_id, COUNT(*) AS duplicate_count
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1;

SELECT supplier_id, COUNT(*) AS duplicate_count
FROM suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;

-- No duplicate primary key found

-- Check missing mandatory values

SELECT COUNT(*) AS missing_customer_names
FROM customers
WHERE customer_name IS NULL OR TRIM(customer_name) = '';

SELECT COUNT(*) AS missing_product_names
FROM products
WHERE product_name IS NULL OR TRIM(product_name) = '';

SELECT COUNT(*) AS missing_sale_dates
FROM sales
WHERE sale_date IS NULL;

SELECT COUNT(*) AS missing_purchase_dates
FROM purchases
WHERE purchase_date IS NULL;

SELECT COUNT(*) AS missing_sale_amounts
FROM sales
WHERE total_amount IS NULL OR net_amount IS NULL;

-- zero missing values found

-- Check invalid values

-- Invalid prices
SELECT *
FROM products
WHERE purchase_price < 0
   OR selling_price < 0
   OR selling_price < purchase_price;

-- Invalid transaction amounts
SELECT *
FROM sales
WHERE total_amount < 0
   OR net_amount < 0;

-- Invalid item quantities or prices
SELECT *
FROM sale_items
WHERE quantity <= 0
   OR unit_price < 0
   OR subtotal < 0;

-- Invalid customer ratings
SELECT *
FROM customer_feedback
WHERE rating NOT BETWEEN 1 AND 5;

-- data integrity checks done and no irregularities found

-- transaction and inventory reconciliation

-- sales total vs sale items

-- SALES HEADER VS SALE ITEMS RECONCILIATION

SELECT
    s.sale_id,
    s.total_amount,
    s.net_amount,
    COALESCE(SUM(si.subtotal), 0) AS calculated_total
FROM sales s
LEFT JOIN sale_items si
    ON s.sale_id = si.sale_id
GROUP BY
    s.sale_id,
    s.total_amount,
    s.net_amount
HAVING
    ROUND(s.total_amount, 2) <> ROUND(calculated_total, 2)
    OR ROUND(s.net_amount, 2) <> ROUND(calculated_total, 2);

-- no such descripencies found

-- Purchase total vs purchase items

SELECT
    p.purchase_id,
    p.total_amount,
    COALESCE(SUM(pi.subtotal), 0) AS calculated_total
FROM purchases p
LEFT JOIN purchase_items pi
    ON p.purchase_id = pi.purchase_id
GROUP BY
    p.purchase_id,
    p.total_amount
HAVING
    ROUND(p.total_amount, 2) <> ROUND(calculated_total, 2);