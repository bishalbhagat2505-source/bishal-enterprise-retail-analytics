
-- =====================================================
-- BISHAL ENTERPRISE
-- BATCH 1: MASTER DATA GENERATION
-- Database: smartphone_wholesale_retail_db
-- =====================================================

USE smartphone_wholesale_retail_db;

-- Allow recursive generation of 2,000 customer records
SET SESSION cte_max_recursion_depth = 3000;


-- =====================================================
-- 1. EMPLOYEES
-- Exactly four employees
-- Two current and two former employees
-- =====================================================

INSERT INTO employees
(employee_name, gender, job_role, city, employment_status)

SELECT *
FROM (
    SELECT
        'Amit Sharma',
        'Male',
        'Store Manager',
        'Siliguri',
        'Active'

    UNION ALL SELECT
        'Priya Das',
        'Female',
        'Sales Executive',
        'Islampur',
        'Active'

    UNION ALL SELECT
        'Rahul Roy',
        'Male',
        'Sales Executive',
        'Siliguri',
        'Former'

    UNION ALL SELECT
        'Sourav Dey',
        'Male',
        'Inventory Executive',
        'Islampur',
        'Former'
) AS employee_data
WHERE NOT EXISTS (
    SELECT 1 FROM employees
);


-- =====================================================
-- 2. BRANDS
-- 13 smartphone brands
-- =====================================================

INSERT IGNORE INTO brands (brand_name)
VALUES
('Vivo'),
('Oppo'),
('Samsung'),
('Apple'),
('Xiaomi'),
('Redmi'),
('Realme'),
('OnePlus'),
('Motorola'),
('Nothing'),
('iQOO'),
('Nokia'),
('Tecno');


-- =====================================================
-- 3. SUPPLIERS
-- 12 synthetic suppliers
-- =====================================================

INSERT INTO suppliers
(supplier_name, phone_number, city)

SELECT *
FROM (
    SELECT 'Eastern Mobile Distributors',
           '9876500001', 'Kolkata'

    UNION ALL SELECT 'North Bengal Telecom',
           '9876500002', 'Siliguri'

    UNION ALL SELECT 'Metro Smartphone Traders',
           '9876500003', 'Delhi'

    UNION ALL SELECT 'Prime Digital Wholesale',
           '9876500004', 'Mumbai'

    UNION ALL SELECT 'Guwahati Mobile Supply',
           '9876500005', 'Guwahati'

    UNION ALL SELECT 'Techno India Distributors',
           '9876500006', 'Kolkata'

    UNION ALL SELECT 'Smartlink Electronics',
           '9876500007', 'Bengaluru'

    UNION ALL SELECT 'Eastern Accessories Hub',
           '9876500008', 'Siliguri'

    UNION ALL SELECT 'National Telecom Supply',
           '9876500009', 'Delhi'

    UNION ALL SELECT 'Digital World Wholesale',
           '9876500010', 'Patna'

    UNION ALL SELECT 'Mobile Galaxy Traders',
           '9876500011', 'Kolkata'

    UNION ALL SELECT 'Northeast Electronics',
           '9876500012', 'Guwahati'
) AS supplier_data
WHERE NOT EXISTS (
    SELECT 1 FROM suppliers
);


-- =====================================================
-- 4. CUSTOMERS
-- Generate 2,000 synthetic customers
-- Indian names, phone numbers and cities
-- =====================================================

INSERT INTO customers
(
    customer_name,
    gender,
    age,
    phone_number,
    city,
    pincode,
    customer_type
)

WITH RECURSIVE customer_numbers AS (

    SELECT 1 AS customer_number

    UNION ALL

    SELECT customer_number + 1
    FROM customer_numbers
    WHERE customer_number < 2000
)

SELECT

    CONCAT(

        CASE MOD(customer_number - 1, 20)
            WHEN 0 THEN 'Aarav'
            WHEN 1 THEN 'Rahul'
            WHEN 2 THEN 'Priya'
            WHEN 3 THEN 'Ananya'
            WHEN 4 THEN 'Rohan'
            WHEN 5 THEN 'Sourav'
            WHEN 6 THEN 'Sneha'
            WHEN 7 THEN 'Amit'
            WHEN 8 THEN 'Riya'
            WHEN 9 THEN 'Arjun'
            WHEN 10 THEN 'Neha'
            WHEN 11 THEN 'Vikash'
            WHEN 12 THEN 'Pooja'
            WHEN 13 THEN 'Abhishek'
            WHEN 14 THEN 'Ankit'
            WHEN 15 THEN 'Kavita'
            WHEN 16 THEN 'Sanjay'
            WHEN 17 THEN 'Meera'
            WHEN 18 THEN 'Rakesh'
            ELSE 'Ishita'
        END,

        ' ',

        CASE MOD(customer_number - 1, 20)
            WHEN 0 THEN 'Sharma'
            WHEN 1 THEN 'Das'
            WHEN 2 THEN 'Roy'
            WHEN 3 THEN 'Dey'
            WHEN 4 THEN 'Bhattacharya'
            WHEN 5 THEN 'Sarkar'
            WHEN 6 THEN 'Ghosh'
            WHEN 7 THEN 'Mondal'
            WHEN 8 THEN 'Barman'
            WHEN 9 THEN 'Singh'
            WHEN 10 THEN 'Gupta'
            WHEN 11 THEN 'Verma'
            WHEN 12 THEN 'Chatterjee'
            WHEN 13 THEN 'Paul'
            WHEN 14 THEN 'Saha'
            WHEN 15 THEN 'Mandal'
            WHEN 16 THEN 'Basu'
            WHEN 17 THEN 'Khan'
            WHEN 18 THEN 'Thapa'
            ELSE 'Pradhan'
        END
    ) AS customer_name,

    CASE
        WHEN MOD(customer_number, 10) < 6 THEN 'Male'
        WHEN MOD(customer_number, 10) < 9 THEN 'Female'
        ELSE 'Other'
    END AS gender,

    18 + MOD(customer_number * 7, 48) AS age,

    CONCAT(
        '9',
        LPAD(100000000 + customer_number, 9, '0')
    ) AS phone_number,

    CASE MOD(customer_number, 10)
        WHEN 0 THEN 'Siliguri'
        WHEN 1 THEN 'Islampur'
        WHEN 2 THEN 'Kolkata'
        WHEN 3 THEN 'Darjeeling'
        WHEN 4 THEN 'Jalpaiguri'
        WHEN 5 THEN 'Raiganj'
        WHEN 6 THEN 'Malda'
        WHEN 7 THEN 'Guwahati'
        WHEN 8 THEN 'Patna'
        ELSE 'Delhi'
    END AS city,

    CASE MOD(customer_number, 10)
        WHEN 0 THEN '734001'
        WHEN 1 THEN '733202'
        WHEN 2 THEN '700001'
        WHEN 3 THEN '734101'
        WHEN 4 THEN '735101'
        WHEN 5 THEN '733134'
        WHEN 6 THEN '732101'
        WHEN 7 THEN '781001'
        WHEN 8 THEN '800001'
        ELSE '110001'
    END AS pincode,

    CASE
        WHEN MOD(customer_number, 4) = 0
            THEN 'Wholesale'
        ELSE 'Retail'
    END AS customer_type

FROM customer_numbers

WHERE NOT EXISTS (
    SELECT 1 FROM customers
);


-- =====================================================
-- 5. MASTER DATA VERIFICATION
-- =====================================================

SELECT 'Employees' AS table_name,
       COUNT(*) AS total_records
FROM employees

UNION ALL

SELECT 'Brands', COUNT(*)
FROM brands

UNION ALL

SELECT 'Suppliers', COUNT(*)
FROM suppliers

UNION ALL

SELECT 'Customers', COUNT(*)
FROM customers;
