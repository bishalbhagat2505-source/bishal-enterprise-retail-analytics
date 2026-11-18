-- Create our smartphone wholesale retail database

CREATE DATABASE IF NOT EXISTS smartphone_wholesale_retail_db;

-- Select the database
USE smartphone_wholesale_retail_db;

-- Verify the selected database
SELECT DATABASE();


-- =========================================================
-- PROJECT: SMARTPHONE WHOLESALE BUSINESS
-- DATABASE: smartphone_wholesale_retail_db
-- PURPOSE: SQL, Data Analytics and Power BI Practice
-- =========================================================

USE smartphone_wholesale_retailG_db;


-- 1. CUSTOMERS
-- Stores customer information.

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    age INT,
    phone_number VARCHAR(15) NOT NULL,
    city VARCHAR(60),
    pincode VARCHAR(10),
    customer_type ENUM('Retail', 'Wholesale') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 2. EMPLOYEES
-- Stores current and former employee information.

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    job_role VARCHAR(60),
    city VARCHAR(60),
    employment_status ENUM('Active', 'Former') DEFAULT 'Active'
);


-- 3. BRANDS
-- Stores mobile and accessory brands.

CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(60) NOT NULL UNIQUE
);


-- 4. SUPPLIERS
-- Stores supplier information.

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15),
    city VARCHAR(60)
);


-- 5. PRODUCTS
-- Stores phones and accessories.

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    brand_id INT NOT NULL,
    category ENUM('Smartphone', 'Accessory') NOT NULL,
    model_number VARCHAR(60),
    ram VARCHAR(20),
    storage VARCHAR(20),
    purchase_price DECIMAL(12,2) NOT NULL,
    selling_price DECIMAL(12,2) NOT NULL,
    product_status ENUM('Active', 'Discontinued') DEFAULT 'Active',

    FOREIGN KEY (brand_id)
        REFERENCES brands(brand_id)
);


-- 6. PURCHASES
-- Stores purchase transaction headers.

CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    employee_id INT,
    purchase_date DATE NOT NULL,
    total_amount DECIMAL(14,2) NOT NULL,
    payment_status ENUM('Paid', 'Partial', 'Unpaid') DEFAULT 'Unpaid',

    FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id),

    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
        ON DELETE SET NULL
);


-- 7. PURCHASE ITEMS
-- Stores individual products in each purchase.

CREATE TABLE purchase_items (
    purchase_item_id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(14,2) NOT NULL,

    FOREIGN KEY (purchase_id)
        REFERENCES purchases(purchase_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


-- 8. INVENTORY
-- Tracks stock received, sold and currently available.

CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL UNIQUE,
    opening_stock INT NOT NULL DEFAULT 0,
    stock_purchased INT NOT NULL DEFAULT 0,
    stock_sold INT NOT NULL DEFAULT 0,
    current_stock INT NOT NULL DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


-- 9. SALES
-- Stores sales transaction headers.

CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    sale_date DATETIME NOT NULL,
    transaction_type ENUM(
        'Smartphone', 'Accessory', 'Repair', 'Mixed'
    ) NOT NULL,
    total_amount DECIMAL(14,2) NOT NULL,
    net_amount DECIMAL(14,2) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE SET NULL,

    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
        ON DELETE SET NULL
);


-- 10. SALE ITEMS
-- Stores individual products sold in each transaction.

CREATE TABLE sale_items (
    sale_item_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(14,2) NOT NULL,

    FOREIGN KEY (sale_id)
        REFERENCES sales(sale_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


-- 11. PAYMENTS
-- Stores individual payment transactions.
-- A payment belongs to either a sale or a purchase.

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT,
    purchase_id INT,
    payment_date DATE NOT NULL,
    payment_method ENUM(
        'Cash', 'UPI', 'Card', 'Bank Transfer', 'EMI'
    ) NOT NULL,
    amount DECIMAL(14,2) NOT NULL,
    payment_status ENUM(
        'Completed', 'Pending', 'Failed'
    ) DEFAULT 'Completed',
    transaction_reference VARCHAR(100),

    FOREIGN KEY (sale_id)
        REFERENCES sales(sale_id),

    FOREIGN KEY (purchase_id)
        REFERENCES purchases(purchase_id),

    CHECK (
        (sale_id IS NOT NULL AND purchase_id IS NULL)
        OR
        (sale_id IS NULL AND purchase_id IS NOT NULL)
    )
);


-- 12. REPAIRS
-- Stores mobile repair service records.

CREATE TABLE repairs (
    repair_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    employee_id INT,
    repair_date DATE NOT NULL,
    repair_type VARCHAR(80),
    problem_description TEXT NOT NULL,
    repair_status ENUM(
        'Received', 'In Progress', 'Completed', 'Delivered'
    ) DEFAULT 'Received',
    estimated_cost DECIMAL(12,2) DEFAULT 0,
    actual_cost DECIMAL(12,2) DEFAULT 0,
    completion_date DATE,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE SET NULL,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE SET NULL,

    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
        ON DELETE SET NULL
);


-- 13. CUSTOMER FEEDBACK
-- Stores customer ratings and reviews.

CREATE TABLE customer_feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    sale_id INT,
    rating INT NOT NULL,
    feedback_text TEXT,
    feedback_date DATE NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (sale_id)
        REFERENCES sales(sale_id),

    CHECK (rating BETWEEN 1 AND 5)
);


-- =========================================================
-- INDEXES
-- Help speed up commonly used searches and joins.
-- =========================================================

CREATE INDEX idx_customers_city
ON customers(city);

CREATE INDEX idx_products_brand
ON products(brand_id);

CREATE INDEX idx_sales_date
ON sales(sale_date);

CREATE INDEX idx_sales_customer
ON sales(customer_id);

CREATE INDEX idx_purchases_date
ON purchases(purchase_date);

CREATE INDEX idx_payments_date
ON payments(payment_date);

CREATE INDEX idx_feedback_customer
ON customer_feedback(customer_id);


-- =========================================================
-- VERIFICATION
-- =========================================================

SHOW TABLES;

SELECT
    COUNT(*) AS total_tables
FROM information_schema.tables
WHERE table_schema = 'smartphone_wholesale_db'
AND table_type = 'BASE TABLE';
