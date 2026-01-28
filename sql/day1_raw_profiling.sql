/* =========================================================
   Consumer360 — Day 1
   Raw Data Profiling & Quality Checks
   ========================================================= */

USE consumer360;

-- ---------------------------------------------------------
-- 1. Total Row Count
-- ---------------------------------------------------------
SELECT COUNT(*) AS total_rows
FROM raw_sales;

-- ---------------------------------------------------------
-- 2. Missing Value Analysis
-- ---------------------------------------------------------
SELECT
 SUM(customer_id IS NULL) AS null_customer_id,
 SUM(description IS NULL) AS null_description,
 SUM(invoice_no IS NULL) AS null_invoice_no,
 SUM(stock_code IS NULL) AS null_stock_code
FROM raw_sales;

-- ---------------------------------------------------------
-- 3. Cancelled Invoices
-- ---------------------------------------------------------
SELECT COUNT(*) AS cancelled_invoices
FROM raw_sales
WHERE invoice_no LIKE 'C%';

-- ---------------------------------------------------------
-- 4. Negative / Zero Quantity or Price
-- ---------------------------------------------------------
SELECT COUNT(*) AS negative_or_zero_rows
FROM raw_sales
WHERE quantity <= 0
   OR unit_price <= 0;

-- ---------------------------------------------------------
-- 5. Date Coverage
-- ---------------------------------------------------------
SELECT
 MIN(invoice_date) AS earliest_invoice,
 MAX(invoice_date) AS latest_invoice
FROM raw_sales;

-- ---------------------------------------------------------
-- 6. Top 10 Countries
-- ---------------------------------------------------------
SELECT
 country,
 COUNT(*) AS transactions
FROM raw_sales
GROUP BY country
ORDER BY transactions DESC
LIMIT 10;

-- ---------------------------------------------------------
-- 7. Distinct Entity Counts
-- ---------------------------------------------------------
SELECT COUNT(DISTINCT customer_id) AS distinct_customers
FROM raw_sales
WHERE customer_id IS NOT NULL;

SELECT COUNT(DISTINCT stock_code) AS distinct_products
FROM raw_sales;

SELECT COUNT(DISTINCT invoice_no) AS distinct_invoices
FROM raw_sales;

-- ---------------------------------------------------------
-- 8. Revenue Sanity Check
-- ---------------------------------------------------------
SELECT
 SUM(quantity * unit_price) AS total_revenue
FROM raw_sales;

-- ---------------------------------------------------------
-- 9. Percentage-Based Quality Metrics
-- ---------------------------------------------------------
SELECT
 ROUND(SUM(customer_id IS NULL) * 100.0 / COUNT(*), 2)
   AS pct_null_customers
FROM raw_sales;

SELECT
 ROUND(SUM(invoice_no LIKE 'C%') * 100.0 / COUNT(*), 2)
   AS pct_cancelled
FROM raw_sales;

SELECT
 ROUND(
   SUM(quantity <= 0 OR unit_price <= 0) * 100.0 / COUNT(*),
   2
 ) AS pct_negative_rows
FROM raw_sales;
