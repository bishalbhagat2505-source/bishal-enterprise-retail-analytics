-- vw_monthly_sales

-- Shows monthly revenue, number of transactions and average order value (AOV)

CREATE OR REPLACE VIEW vw_monthly_sales AS

SELECT YEAR(s.sale_date) AS sales_year,MONTH(s.sale_date) AS sales_month,
    COUNT(s.sale_id) AS total_transactions,
    SUM(s.total_amount) AS monthly_revenue,
    ROUND(AVG(net_amount), 2) AS average_order_value
 
FROM sales s
GROUP BY YEAR(s.sale_date),MONTH(s.sale_date);


-- Product performance – vw_product_performance
-- Product-wise revenue, units sold and average selling price

CREATE OR REPLACE VIEW vw_product_performance AS

SELECT
    p.product_id,
    p.product_name,
    p.category,
    b.brand_name,
    SUM(si.quantity) AS units_sold,
    SUM(si.subtotal) AS total_revenue,
    ROUND(SUM(si.subtotal) / SUM(si.quantity), 2) AS average_selling_price

FROM products p

JOIN brands b
    ON p.brand_id = b.brand_id

JOIN sale_items si
    ON p.product_id = si.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    b.brand_name;



-- Brand performance  vw_brand_performance
-- Brand-wise revenue and sales volume



CREATE OR REPLACE VIEW vw_brand_performance AS

SELECT
    b.brand_id,
    b.brand_name,
    COUNT(DISTINCT s.sale_id) AS total_transactions,
    SUM(si.quantity) AS units_sold,
    SUM(si.subtotal) AS total_revenue
FROM brands b
JOIN products p
    ON b.brand_id = p.brand_id
JOIN sale_items si
    ON p.product_id = si.product_id
JOIN sales s
    ON si.sale_id = s.sale_id
GROUP BY
    b.brand_id,
    b.brand_name;



-- Customer summary – vw_customer_summary
-- Customer spending, transaction count and last purchase


CREATE OR REPLACE VIEW vw_customer_summary AS

SELECT
    c.customer_id,
    c.customer_name,
    c.customer_type,
    c.city,
    COUNT(s.sale_id) AS total_transactions,
    COALESCE(SUM(s.net_amount), 0) AS total_spending,
    ROUND(AVG(s.net_amount), 2) AS average_purchase_value,
    MAX(s.sale_date) AS last_purchase_date
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.customer_type,
    c.city;



-- Employee performance – vw_employee_performance
-- Employee-wise sales and revenue


CREATE OR REPLACE VIEW vw_employee_performance AS

SELECT
    e.employee_id,
    e.employee_name,
    e.job_role,
    e.employment_status,
    COUNT(s.sale_id) AS total_transactions,
    COALESCE(SUM(s.net_amount), 0) AS total_revenue,
    ROUND(AVG(s.net_amount), 2) AS average_sale_value
FROM employees e
LEFT JOIN sales s
    ON e.employee_id = s.employee_id
GROUP BY
    e.employee_id,
    e.employee_name,
    e.job_role,
    e.employment_status;


-- Inventory status – vw_inventory_status
-- Product stock, available quantity and inventory valuation


CREATE OR REPLACE VIEW vw_inventory_status AS

SELECT
    p.product_id,
    p.product_name,
    p.category,
    i.opening_stock,
    i.stock_purchased,
    i.stock_sold,
    i.current_stock,
    p.purchase_price,
    p.selling_price,
    CASE
        WHEN i.current_stock = 0 THEN 'Out of Stock'
        ELSE 'In Stock'
    END AS stock_status,
    (i.current_stock * p.purchase_price) AS inventory_value,
    (i.current_stock * p.selling_price) AS potential_sales_value
FROM products p
JOIN inventory i
    ON p.product_id = i.product_id;




-- Supplier performance – vw_supplier_performance
-- Supplier-wise purchase transactions and purchase value

CREATE OR REPLACE VIEW vw_supplier_performance AS

SELECT
    s.supplier_id,
    s.supplier_name,
    s.city,
    COUNT(p.purchase_id) AS total_purchases,
    COALESCE(SUM(p.total_amount), 0) AS total_purchase_value,
    MAX(p.purchase_date) AS last_purchase_date,
    ROUND(AVG(p.total_amount), 2) AS average_purchase_value
FROM suppliers s
LEFT JOIN purchases p
    ON s.supplier_id = p.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.city;


-- Payment summary – vw_payment_summary
-- Sales amount, amount collected and outstanding balance


CREATE OR REPLACE VIEW vw_payment_summary AS

SELECT
    s.sale_id,
    s.sale_date,
    s.total_amount,
    s.net_amount AS sales_amount,
    COALESCE(p.amount_collected, 0) AS amount_collected,
    GREATEST(
        s.net_amount - COALESCE(p.amount_collected, 0),
        0
    ) AS outstanding_balance,
    CASE
        WHEN COALESCE(p.amount_collected, 0) = 0
            THEN 'Unpaid'
        WHEN p.amount_collected < s.net_amount
            THEN 'Partially Paid'
        ELSE 'Paid'
    END AS payment_status
FROM sales s
LEFT JOIN (
    SELECT
        sale_id,
        SUM(amount) AS amount_collected
    FROM payments
    WHERE sale_id IS NOT NULL
      AND payment_status = 'Completed'
    GROUP BY sale_id

) p
    ON s.sale_id = p.sale_id;





-- Purchase vs sales – vw_purchase_sales_comparison
-- Monthly purchases versus monthly sales

CREATE OR REPLACE VIEW vw_purchase_sales_comparison AS

SELECT
    m.month_name,
    COALESCE(s.monthly_sales, 0) AS monthly_sales,
    COALESCE(p.monthly_purchases, 0) AS monthly_purchases,
    COALESCE(s.monthly_sales, 0)
        - COALESCE(p.monthly_purchases, 0) AS difference
FROM (
    SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month_name
    FROM sales
    UNION
    SELECT DATE_FORMAT(purchase_date, '%Y-%m')
    FROM purchases
) m
LEFT JOIN (
    SELECT
        DATE_FORMAT(sale_date, '%Y-%m') AS month_name,
        SUM(net_amount) AS monthly_sales
    FROM sales
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
) s
    ON m.month_name = s.month_name
LEFT JOIN (
    SELECT
        DATE_FORMAT(purchase_date, '%Y-%m') AS month_name,
        SUM(total_amount) AS monthly_purchases
    FROM purchases
    GROUP BY DATE_FORMAT(purchase_date, '%Y-%m')
) p
    ON m.month_name = p.month_name;


-- Business dashboard – vw_business_dashboard
-- Consolidated business KPIs.


CREATE OR REPLACE VIEW vw_business_dashboard AS

SELECT

    (SELECT COUNT(*)
     FROM customers) AS total_customers,
    (SELECT COUNT(*)
     FROM products) AS total_products,
    (SELECT COUNT(*)
     FROM employees
     WHERE employment_status = 'Active') AS active_employees,
    (SELECT COUNT(*)
     FROM sales) AS total_transactions,
    (SELECT COALESCE(SUM(net_amount), 0)
     FROM sales) AS total_revenue,
    (SELECT COALESCE(AVG(net_amount), 0)
     FROM sales) AS average_order_value,
    (SELECT COALESCE(SUM(current_stock), 0)
     FROM inventory) AS total_stock,
    (SELECT COALESCE(SUM(i.current_stock * p.purchase_price), 0)
     FROM inventory i
     JOIN products p
        ON i.product_id = p.product_id) AS inventory_value,
    (SELECT COALESCE(SUM(total_amount), 0)
     FROM purchases) AS total_purchase_value,
    (SELECT COALESCE(SUM(amount), 0)
     FROM payments
     WHERE sale_id IS NOT NULL
       AND payment_status = 'Completed') AS total_payments_collected,
    (SELECT COUNT(*)
     FROM repairs
     WHERE repair_status IN ('Completed', 'Delivered')) AS completed_repairs,
    (SELECT COALESCE(SUM(actual_cost), 0)
     FROM repairs
     WHERE repair_status IN ('Completed', 'Delivered')) AS repair_revenue;



SELECT *
FROM vw_business_dashboard;

