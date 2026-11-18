
-- =========================================================
-- BISHAL ENTERPRISE
-- BATCH 2: PRODUCT CATALOGUE GENERATION
-- Database: smartphone_wholesale_retail_db
-- Target: 70 Products
-- =========================================================

USE smartphone_wholesale_retail_db;


-- =========================================================
-- STEP 1: INSERT PRODUCTS
-- Products are linked to brands using brand_name.
-- This avoids manually guessing brand_id values.
-- =========================================================

INSERT INTO products
(
    product_name,
    brand_id,
    category,
    model_number,
    ram,
    storage,
    purchase_price,
    selling_price,
    product_status
)

SELECT
    p.product_name,
    b.brand_id,
    p.category,
    p.model_number,
    p.ram,
    p.storage,
    p.purchase_price,
    p.selling_price,
    p.product_status

FROM (

    SELECT 'Vivo V40' AS product_name, 'Vivo' AS brand_name,
    'Smartphone' AS category, 'V40-8-128' AS model_number,
    '8GB' AS ram, '128GB' AS storage, 28500 AS purchase_price,
    32999 AS selling_price, 'Active' AS product_status

    UNION ALL SELECT 'Vivo V40 Pro', 'Vivo', 'Smartphone',
    'V40P-8-256', '8GB', '256GB', 38500, 45999, 'Active'

    UNION ALL SELECT 'Vivo Y200', 'Vivo', 'Smartphone',
    'Y200-8-128', '8GB', '128GB', 17500, 20999, 'Active'

    UNION ALL SELECT 'Vivo T3x', 'Vivo', 'Smartphone',
    'T3X-6-128', '6GB', '128GB', 11500, 13999, 'Active'

    UNION ALL SELECT 'Vivo Y28', 'Vivo', 'Smartphone',
    'Y28-8-128', '8GB', '128GB', 12500, 14999, 'Discontinued'

    UNION ALL SELECT 'Oppo Reno 12', 'Oppo', 'Smartphone',
    'R12-8-256', '8GB', '256GB', 26500, 29999, 'Active'

    UNION ALL SELECT 'Oppo Reno 12 Pro', 'Oppo', 'Smartphone',
    'R12P-12-256', '12GB', '256GB', 36500, 40999, 'Active'

    UNION ALL SELECT 'Oppo F27 Pro+', 'Oppo', 'Smartphone',
    'F27P-8-128', '8GB', '128GB', 24500, 27999, 'Active'

    UNION ALL SELECT 'Oppo A3 Pro', 'Oppo', 'Smartphone',
    'A3P-8-128', '8GB', '128GB', 15500, 17999, 'Active'

    UNION ALL SELECT 'Oppo A59', 'Oppo', 'Smartphone',
    'A59-6-128', '6GB', '128GB', 10500, 12999, 'Discontinued'

    UNION ALL SELECT 'Samsung Galaxy S24', 'Samsung', 'Smartphone',
    'S24-8-256', '8GB', '256GB', 58500, 64999, 'Active'

    UNION ALL SELECT 'Samsung Galaxy S24 Ultra', 'Samsung', 'Smartphone',
    'S24U-12-256', '12GB', '256GB', 98500, 109999, 'Active'

    UNION ALL SELECT 'Samsung Galaxy A55', 'Samsung', 'Smartphone',
    'A55-8-128', '8GB', '128GB', 27500, 32999, 'Active'

    UNION ALL SELECT 'Samsung Galaxy A35', 'Samsung', 'Smartphone',
    'A35-8-128', '8GB', '128GB', 21500, 25999, 'Active'

    UNION ALL SELECT 'Samsung Galaxy M34', 'Samsung', 'Smartphone',
    'M34-6-128', '6GB', '128GB', 14500, 16999, 'Discontinued'

    UNION ALL SELECT 'iPhone 15', 'Apple', 'Smartphone',
    'IP15-128', NULL, '128GB', 57500, 64900, 'Active'

    UNION ALL SELECT 'iPhone 15 Plus', 'Apple', 'Smartphone',
    'IP15P-128', NULL, '128GB', 66500, 74900, 'Active'

    UNION ALL SELECT 'iPhone 15 Pro', 'Apple', 'Smartphone',
    'IP15PRO-256', NULL, '256GB', 89500, 99900, 'Active'

    UNION ALL SELECT 'iPhone 14', 'Apple', 'Smartphone',
    'IP14-128', NULL, '128GB', 47500, 54900, 'Active'

    UNION ALL SELECT 'iPhone 13', 'Apple', 'Smartphone',
    'IP13-128', NULL, '128GB', 39500, 44900, 'Discontinued'

    UNION ALL SELECT 'Xiaomi 14', 'Xiaomi', 'Smartphone',
    'X14-12-512', '12GB', '512GB', 48500, 54999, 'Active'

    UNION ALL SELECT 'Xiaomi 14 Civi', 'Xiaomi', 'Smartphone',
    'X14C-8-256', '8GB', '256GB', 38500, 42999, 'Active'

    UNION ALL SELECT 'Xiaomi 13 Pro', 'Xiaomi', 'Smartphone',
    'X13P-12-256', '12GB', '256GB', 46500, 52999, 'Discontinued'

    UNION ALL SELECT 'Redmi Note 13 Pro+', 'Redmi', 'Smartphone',
    'RN13P-8-256', '8GB', '256GB', 24500, 28999, 'Active'

    UNION ALL SELECT 'Redmi Note 13', 'Redmi', 'Smartphone',
    'RN13-6-128', '6GB', '128GB', 13500, 15999, 'Active'

    UNION ALL SELECT 'Redmi 13C', 'Redmi', 'Smartphone',
    'R13C-4-128', '4GB', '128GB', 7500, 8999, 'Active'

    UNION ALL SELECT 'Redmi 12 5G', 'Redmi', 'Smartphone',
    'R12-6-128', '6GB', '128GB', 10500, 12999, 'Discontinued'

    UNION ALL SELECT 'Realme 12 Pro+', 'Realme', 'Smartphone',
    'R12P-8-256', '8GB', '256GB', 25500, 29999, 'Active'

    UNION ALL SELECT 'Realme 12 Pro', 'Realme', 'Smartphone',
    'R12PRO-8-128', '8GB', '128GB', 20500, 23999, 'Active'

    UNION ALL SELECT 'Realme Narzo 70 Pro', 'Realme', 'Smartphone',
    'N70P-8-128', '8GB', '128GB', 17500, 19999, 'Active'

    UNION ALL SELECT 'Realme C67', 'Realme', 'Smartphone',
    'C67-6-128', '6GB', '128GB', 10500, 12999, 'Discontinued'

    UNION ALL SELECT 'OnePlus 12', 'OnePlus', 'Smartphone',
    'OP12-12-256', '12GB', '256GB', 54500, 64999, 'Active'

    UNION ALL SELECT 'OnePlus 12R', 'OnePlus', 'Smartphone',
    'OP12R-8-256', '8GB', '256GB', 34500, 39999, 'Active'

    UNION ALL SELECT 'OnePlus Nord CE4', 'OnePlus', 'Smartphone',
    'NCE4-8-128', '8GB', '128GB', 21500, 24999, 'Active'

    UNION ALL SELECT 'OnePlus Nord 3', 'OnePlus', 'Smartphone',
    'N3-8-128', '8GB', '128GB', 26500, 29999, 'Discontinued'

    UNION ALL SELECT 'Moto Edge 50 Pro', 'Motorola', 'Smartphone',
    'ME50P-8-256', '8GB', '256GB', 28500, 31999, 'Active'

    UNION ALL SELECT 'Moto G85', 'Motorola', 'Smartphone',
    'MG85-8-128', '8GB', '128GB', 16500, 18999, 'Active'

    UNION ALL SELECT 'Moto G64', 'Motorola', 'Smartphone',
    'MG64-8-128', '8GB', '128GB', 12500, 14999, 'Active'

    UNION ALL SELECT 'Moto G54', 'Motorola', 'Smartphone',
    'MG54-8-128', '8GB', '128GB', 11500, 13999, 'Discontinued'

    UNION ALL SELECT 'Nothing Phone 2', 'Nothing', 'Smartphone',
    'NP2-12-256', '12GB', '256GB', 35500, 39999, 'Active'

    UNION ALL SELECT 'Nothing Phone 2a', 'Nothing', 'Smartphone',
    'NP2A-8-128', '8GB', '128GB', 20500, 23999, 'Active'

    UNION ALL SELECT 'Nothing Phone 2a Plus', 'Nothing', 'Smartphone',
    'NP2AP-8-256', '8GB', '256GB', 24500, 27999, 'Active'

    UNION ALL SELECT 'iQOO Neo 9 Pro', 'iQOO', 'Smartphone',
    'IQN9P-8-256', '8GB', '256GB', 32500, 36999, 'Active'

    UNION ALL SELECT 'iQOO Z9', 'iQOO', 'Smartphone',
    'IQZ9-8-128', '8GB', '128GB', 16500, 18999, 'Active'

    UNION ALL SELECT 'iQOO Z9x', 'iQOO', 'Smartphone',
    'IQZ9X-6-128', '6GB', '128GB', 11500, 13999, 'Active'

    UNION ALL SELECT 'Nokia G42', 'Nokia', 'Smartphone',
    'NG42-6-128', '6GB', '128GB', 10500, 12999, 'Discontinued'

    UNION ALL SELECT 'Nokia C32', 'Nokia', 'Smartphone',
    'NC32-4-64', '4GB', '64GB', 6500, 7999, 'Active'

    UNION ALL SELECT 'Nokia X30', 'Nokia', 'Smartphone',
    'NX30-8-256', '8GB', '256GB', 18500, 21999, 'Discontinued'

    UNION ALL SELECT 'Tecno Camon 30', 'Tecno', 'Smartphone',
    'TC30-8-256', '8GB', '256GB', 15500, 17999, 'Active'

    UNION ALL SELECT 'Tecno Pova 6', 'Tecno', 'Smartphone',
    'TP6-8-256', '8GB', '256GB', 14500, 16999, 'Active'

    UNION ALL SELECT 'Tecno Spark 20', 'Tecno', 'Smartphone',
    'TS20-8-128', '8GB', '128GB', 8500, 9999, 'Active'

    UNION ALL SELECT 'Tecno Phantom V Flip', 'Tecno', 'Smartphone',
    'TPVF-8-256', '8GB', '256GB', 42500, 49999, 'Active'

    -- ACCESSORIES: 15 PRODUCTS

    UNION ALL SELECT 'Vivo Type C Charger 44W', 'Vivo',
    'Accessory', 'VC44W', NULL, NULL, 450, 699, 'Active'

    UNION ALL SELECT 'Oppo Type C Charger 67W', 'Oppo',
    'Accessory', 'OC67W', NULL, NULL, 750, 1099, 'Active'

    UNION ALL SELECT 'Samsung 25W Adapter', 'Samsung',
    'Accessory', 'SA25W', NULL, NULL, 650, 999, 'Active'

    UNION ALL SELECT 'Apple 20W Adapter', 'Apple',
    'Accessory', 'AA20W', NULL, NULL, 1200, 1499, 'Active'

    UNION ALL SELECT 'Xiaomi Power Bank 10000mAh', 'Xiaomi',
    'Accessory', 'XPB10K', NULL, NULL, 850, 1199, 'Active'

    UNION ALL SELECT 'Redmi Buds 5', 'Redmi',
    'Accessory', 'RB5', NULL, NULL, 1400, 1999, 'Active'

    UNION ALL SELECT 'Realme Buds T300', 'Realme',
    'Accessory', 'RBT300', NULL, NULL, 1600, 2199, 'Active'

    UNION ALL SELECT 'OnePlus Nord Buds 2', 'OnePlus',
    'Accessory', 'ONB2', NULL, NULL, 1700, 2299, 'Active'

    UNION ALL SELECT 'Motorola Wireless Earbuds', 'Motorola',
    'Accessory', 'MWEB1', NULL, NULL, 1100, 1599, 'Active'

    UNION ALL SELECT 'Nothing Ear Stick', 'Nothing',
    'Accessory', 'NES1', NULL, NULL, 3500, 4499, 'Discontinued'

    UNION ALL SELECT 'iQOO Type C Cable', 'iQOO',
    'Accessory', 'IQCC1', NULL, NULL, 150, 299, 'Active'

    UNION ALL SELECT 'Nokia Wired Earphones', 'Nokia',
    'Accessory', 'NWE1', NULL, NULL, 180, 349, 'Active'

    UNION ALL SELECT 'Tecno Power Bank 20000mAh', 'Tecno',
    'Accessory', 'TPB20K', NULL, NULL, 1100, 1499, 'Active'

    UNION ALL SELECT 'Samsung Wireless Charger', 'Samsung',
    'Accessory', 'SWC1', NULL, NULL, 1400, 1999, 'Active'

    UNION ALL SELECT 'Universal Tempered Glass', 'Vivo',
    'Accessory', 'UTG1', NULL, NULL, 45, 99, 'Discontinued'

) AS p

INNER JOIN brands AS b
    ON b.brand_name = p.brand_name

WHERE NOT EXISTS (
    SELECT 1
    FROM products AS existing_product
    WHERE existing_product.product_name = p.product_name
);


-- =========================================================
-- STEP 2: PRODUCT CATALOGUE VERIFICATION
-- =========================================================

SELECT
    COUNT(*) AS total_products,
    SUM(category = 'Smartphone') AS smartphones,
    SUM(category = 'Accessory') AS accessories,
    SUM(product_status = 'Active') AS active_products,
    SUM(product_status = 'Discontinued') AS discontinued_products
FROM products;


-- =========================================================
-- STEP 3: BRAND-WISE PRODUCT DISTRIBUTION
-- =========================================================

SELECT
    b.brand_name,
    COUNT(p.product_id) AS total_products
FROM brands b
LEFT JOIN products p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_id, b.brand_name
ORDER BY total_products DESC;


-- =========================================================
-- STEP 4: CHECK PRODUCT PRICING
-- =========================================================

SELECT
    product_name,
    purchase_price,
    selling_price,
    (selling_price - purchase_price) AS gross_margin,
    ROUND(
        (selling_price - purchase_price) /
        NULLIF(selling_price, 0) * 100,
        2
    ) AS margin_percentage
FROM products
ORDER BY margin_percentage DESC;
