
USE smartphone_wholesale_retail_db;

-- =====================================================
-- BATCH 08: REPAIRS AND CUSTOMER FEEDBACK
-- Repairs: 200 records
-- Customer Feedback: 1,100 records
-- Data period: 2025
-- =====================================================


-- -----------------------------------------------------
-- PART 1: GENERATE 200 REPAIR RECORDS
-- -----------------------------------------------------

INSERT INTO repairs
(
    customer_id,
    product_id,
    employee_id,
    repair_date,
    repair_type,
    problem_description,
    repair_status,
    estimated_cost,
    actual_cost,
    completion_date
)
SELECT
    c.customer_id,
    p.product_id,
    e.employee_id,

    -- Spread repair dates across 2025
    DATE_ADD(
        '2025-01-01',
        INTERVAL MOD(n.repair_no * 19, 365) DAY
    ) AS repair_date,

    CASE MOD(n.repair_no, 6)
        WHEN 0 THEN 'Screen Replacement'
        WHEN 1 THEN 'Battery Replacement'
        WHEN 2 THEN 'Charging Port Repair'
        WHEN 3 THEN 'Software Issue'
        WHEN 4 THEN 'Speaker Repair'
        ELSE 'Other Hardware Repair'
    END AS repair_type,

    CASE MOD(n.repair_no, 8)
        WHEN 0 THEN 'Cracked display and touch response issue'
        WHEN 1 THEN 'Battery draining unusually fast'
        WHEN 2 THEN 'Device not charging properly'
        WHEN 3 THEN 'Phone hanging and restarting frequently'
        WHEN 4 THEN 'Speaker volume very low'
        WHEN 5 THEN 'Network connectivity problem'
        WHEN 6 THEN 'Camera not functioning correctly'
        ELSE 'General hardware inspection required'
    END AS problem_description,

    CASE
        WHEN MOD(n.repair_no, 10) IN (0, 1)
            THEN 'Received'
        WHEN MOD(n.repair_no, 10) IN (2, 3)
            THEN 'In Progress'
        WHEN MOD(n.repair_no, 10) IN (4, 5, 6)
            THEN 'Completed'
        ELSE 'Delivered'
    END AS repair_status,

    -- Estimated repair cost
    300 + MOD(n.repair_no * 137, 4700) AS estimated_cost,

    -- Actual cost is recorded only after completion
    CASE
        WHEN MOD(n.repair_no, 10) IN (4, 5, 6, 7, 8, 9)
            THEN 300 + MOD(n.repair_no * 149, 5000)
        ELSE NULL
    END AS actual_cost,

    -- Completion date only for completed/delivered repairs
    CASE
        WHEN MOD(n.repair_no, 10) IN (4, 5, 6, 7, 8, 9)
            THEN DATE_ADD(
                DATE_ADD('2025-01-01',
                    INTERVAL MOD(n.repair_no * 19, 365) DAY
                ),
                INTERVAL (2 + MOD(n.repair_no, 8)) DAY
            )
        ELSE NULL
    END AS completion_date

FROM
(
    SELECT 1 AS repair_no
    UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
    UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13
    UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16
    UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
    UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22
    UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL SELECT 25
    UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28
    UNION ALL SELECT 29 UNION ALL SELECT 30 UNION ALL SELECT 31
    UNION ALL SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34
    UNION ALL SELECT 35 UNION ALL SELECT 36 UNION ALL SELECT 37
    UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40
    UNION ALL SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43
    UNION ALL SELECT 44 UNION ALL SELECT 45 UNION ALL SELECT 46
    UNION ALL SELECT 47 UNION ALL SELECT 48 UNION ALL SELECT 49
    UNION ALL SELECT 50 UNION ALL SELECT 51 UNION ALL SELECT 52
    UNION ALL SELECT 53 UNION ALL SELECT 54 UNION ALL SELECT 55
    UNION ALL SELECT 56 UNION ALL SELECT 57 UNION ALL SELECT 58
    UNION ALL SELECT 59 UNION ALL SELECT 60 UNION ALL SELECT 61
    UNION ALL SELECT 62 UNION ALL SELECT 63 UNION ALL SELECT 64
    UNION ALL SELECT 65 UNION ALL SELECT 66 UNION ALL SELECT 67
    UNION ALL SELECT 68 UNION ALL SELECT 69 UNION ALL SELECT 70
    UNION ALL SELECT 71 UNION ALL SELECT 72 UNION ALL SELECT 73
    UNION ALL SELECT 74 UNION ALL SELECT 75 UNION ALL SELECT 76
    UNION ALL SELECT 77 UNION ALL SELECT 78 UNION ALL SELECT 79
    UNION ALL SELECT 80 UNION ALL SELECT 81 UNION ALL SELECT 82
    UNION ALL SELECT 83 UNION ALL SELECT 84 UNION ALL SELECT 85
    UNION ALL SELECT 86 UNION ALL SELECT 87 UNION ALL SELECT 88
    UNION ALL SELECT 89 UNION ALL SELECT 90 UNION ALL SELECT 91
    UNION ALL SELECT 92 UNION ALL SELECT 93 UNION ALL SELECT 94
    UNION ALL SELECT 95 UNION ALL SELECT 96 UNION ALL SELECT 97
    UNION ALL SELECT 98 UNION ALL SELECT 99 UNION ALL SELECT 100
    UNION ALL SELECT 101 UNION ALL SELECT 102 UNION ALL SELECT 103
    UNION ALL SELECT 104 UNION ALL SELECT 105 UNION ALL SELECT 106
    UNION ALL SELECT 107 UNION ALL SELECT 108 UNION ALL SELECT 109
    UNION ALL SELECT 110 UNION ALL SELECT 111 UNION ALL SELECT 112
    UNION ALL SELECT 113 UNION ALL SELECT 114 UNION ALL SELECT 115
    UNION ALL SELECT 116 UNION ALL SELECT 117 UNION ALL SELECT 118
    UNION ALL SELECT 119 UNION ALL SELECT 120 UNION ALL SELECT 121
    UNION ALL SELECT 122 UNION ALL SELECT 123 UNION ALL SELECT 124
    UNION ALL SELECT 125 UNION ALL SELECT 126 UNION ALL SELECT 127
    UNION ALL SELECT 128 UNION ALL SELECT 129 UNION ALL SELECT 130
    UNION ALL SELECT 131 UNION ALL SELECT 132 UNION ALL SELECT 133
    UNION ALL SELECT 134 UNION ALL SELECT 135 UNION ALL SELECT 136
    UNION ALL SELECT 137 UNION ALL SELECT 138 UNION ALL SELECT 139
    UNION ALL SELECT 140 UNION ALL SELECT 141 UNION ALL SELECT 142
    UNION ALL SELECT 143 UNION ALL SELECT 144 UNION ALL SELECT 145
    UNION ALL SELECT 146 UNION ALL SELECT 147 UNION ALL SELECT 148
    UNION ALL SELECT 149 UNION ALL SELECT 150 UNION ALL SELECT 151
    UNION ALL SELECT 152 UNION ALL SELECT 153 UNION ALL SELECT 154
    UNION ALL SELECT 155 UNION ALL SELECT 156 UNION ALL SELECT 157
    UNION ALL SELECT 158 UNION ALL SELECT 159 UNION ALL SELECT 160
    UNION ALL SELECT 161 UNION ALL SELECT 162 UNION ALL SELECT 163
    UNION ALL SELECT 164 UNION ALL SELECT 165 UNION ALL SELECT 166
    UNION ALL SELECT 167 UNION ALL SELECT 168 UNION ALL SELECT 169
    UNION ALL SELECT 170 UNION ALL SELECT 171 UNION ALL SELECT 172
    UNION ALL SELECT 173 UNION ALL SELECT 174 UNION ALL SELECT 175
    UNION ALL SELECT 176 UNION ALL SELECT 177 UNION ALL SELECT 178
    UNION ALL SELECT 179 UNION ALL SELECT 180 UNION ALL SELECT 181
    UNION ALL SELECT 182 UNION ALL SELECT 183 UNION ALL SELECT 184
    UNION ALL SELECT 185 UNION ALL SELECT 186 UNION ALL SELECT 187
    UNION ALL SELECT 188 UNION ALL SELECT 189 UNION ALL SELECT 190
    UNION ALL SELECT 191 UNION ALL SELECT 192 UNION ALL SELECT 193
    UNION ALL SELECT 194 UNION ALL SELECT 195 UNION ALL SELECT 196
    UNION ALL SELECT 197 UNION ALL SELECT 198 UNION ALL SELECT 199
    UNION ALL SELECT 200
) AS n

CROSS JOIN
(
    SELECT customer_id,
           ROW_NUMBER() OVER (ORDER BY customer_id) AS rn
    FROM customers
) AS c

CROSS JOIN
(
    SELECT product_id,
           ROW_NUMBER() OVER (ORDER BY product_id) AS rn
    FROM products
    WHERE category = 'Smartphone'
) AS p

CROSS JOIN
(
    SELECT employee_id,
           ROW_NUMBER() OVER (ORDER BY employee_id) AS rn
    FROM employees
) AS e

WHERE
    c.rn = MOD(n.repair_no * 37 - 1,
               (SELECT COUNT(*) FROM customers)) + 1
    AND p.rn = MOD(n.repair_no * 7 - 1,
                   (SELECT COUNT(*) FROM products
                    WHERE category = 'Smartphone')) + 1
    AND e.rn = MOD(n.repair_no * 3 - 1,
                   (SELECT COUNT(*) FROM employees)) + 1

    -- Prevent rerunning the complete batch accidentally
    AND NOT EXISTS (SELECT 1 FROM repairs);


-- -----------------------------------------------------
-- PART 2: GENERATE 1,100 CUSTOMER FEEDBACK RECORDS
-- Each feedback record belongs to a real sale.
-- Customer ID is taken from that sale.
-- -----------------------------------------------------

INSERT INTO customer_feedback
(
    customer_id,
    sale_id,
    rating,
    feedback_text,
    feedback_date
)
WITH ranked_sales AS
(
    SELECT
        s.sale_id,
        s.customer_id,
        s.sale_date,
        ROW_NUMBER() OVER (ORDER BY s.sale_id) AS rn
    FROM sales s
)
SELECT
    rs.customer_id,
    rs.sale_id,

    CASE
        WHEN MOD(rs.rn, 100) < 40 THEN 5
        WHEN MOD(rs.rn, 100) < 75 THEN 4
        WHEN MOD(rs.rn, 100) < 90 THEN 3
        WHEN MOD(rs.rn, 100) < 97 THEN 2
        ELSE 1
    END AS rating,

    CASE MOD(rs.rn, 12)
        WHEN 0 THEN 'Excellent service and smooth experience.'
        WHEN 1 THEN 'Good product and helpful staff.'
        WHEN 2 THEN 'Satisfied with the purchase.'
        WHEN 3 THEN 'Quick service and reasonable pricing.'
        WHEN 4 THEN 'Product quality was very good.'
        WHEN 5 THEN 'Staff explained the product properly.'
        WHEN 6 THEN 'Delivery and billing process was smooth.'
        WHEN 7 THEN 'Average experience, could be improved.'
        WHEN 8 THEN 'Had to wait longer than expected.'
        WHEN 9 THEN 'Product was good but service was average.'
        WHEN 10 THEN 'Not fully satisfied with the experience.'
        ELSE 'Poor experience. Needs improvement.'
    END AS feedback_text,

    DATE_ADD(
        rs.sale_date,
        INTERVAL (1 + MOD(rs.rn, 10)) DAY
    ) AS feedback_date

FROM ranked_sales rs
WHERE rs.rn <= 1100
  AND NOT EXISTS (SELECT 1 FROM customer_feedback);


-- =====================================================
-- PART 3: VALIDATION
-- Run these queries after the inserts.
-- =====================================================

-- Total repairs
SELECT COUNT(*) AS total_repairs
FROM repairs;

-- Repair status distribution
SELECT
    repair_status,
    COUNT(*) AS total
FROM repairs
GROUP BY repair_status
ORDER BY total DESC;

-- Repair type distribution
SELECT
    repair_type,
    COUNT(*) AS total
FROM repairs
GROUP BY repair_type
ORDER BY total DESC;

-- Total customer feedback
SELECT COUNT(*) AS total_feedback
FROM customer_feedback;

-- Rating distribution
SELECT
    rating,
    COUNT(*) AS total_feedback
FROM customer_feedback
GROUP BY rating
ORDER BY rating DESC;

-- Check that feedback customer matches the sale customer
SELECT COUNT(*) AS mismatched_feedback
FROM customer_feedback cf
JOIN sales s
    ON cf.sale_id = s.sale_id
WHERE cf.customer_id <> s.customer_id;

-- Check invalid repair relationships
SELECT COUNT(*) AS invalid_repairs
FROM repairs r
LEFT JOIN customers c ON r.customer_id = c.customer_id
LEFT JOIN products p ON r.product_id = p.product_id
LEFT JOIN employees e ON r.employee_id = e.employee_id
WHERE c.customer_id IS NULL
   OR p.product_id IS NULL
   OR e.employee_id IS NULL;

-- Check completion dates
SELECT COUNT(*) AS invalid_completion_dates
FROM repairs
WHERE completion_date < repair_date;
