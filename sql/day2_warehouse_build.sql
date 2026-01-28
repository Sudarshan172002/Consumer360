/* ============================================================
   Consumer360 — DAY 2
   Data Warehouse Build: Staging + Star Schema + Fact Load
   ============================================================ */

USE consumer360;

-- ============================================================
-- TASK 1 — Create Clean Staging Table
-- ============================================================

DROP TABLE IF EXISTS staging_sales_clean;

CREATE TABLE staging_sales_clean AS
SELECT
 invoice_no,
 stock_code,
 TRIM(description) AS description,
 quantity,
 invoice_date,
 unit_price,
 customer_id,
 country
FROM raw_sales
WHERE quantity > 0
  AND unit_price > 0
  AND invoice_no NOT LIKE 'C%'
  AND customer_id IS NOT NULL;

-- ============================================================
-- TASK 2 — Create Star Schema Tables
-- ============================================================

DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS fact_sales;

CREATE TABLE dim_customer (
 customer_key INT AUTO_INCREMENT PRIMARY KEY,
 customer_id INT,
 country VARCHAR(100),
 first_purchase_date DATE
);

CREATE TABLE dim_product (
 product_key INT AUTO_INCREMENT PRIMARY KEY,
 stock_code VARCHAR(50),
 description TEXT
);

CREATE TABLE dim_date (
 date_key INT AUTO_INCREMENT PRIMARY KEY,
 full_date DATE,
 year INT,
 month INT,
 week INT,
 weekday INT
);

CREATE TABLE fact_sales (
 sale_key INT AUTO_INCREMENT PRIMARY KEY,
 invoice_no VARCHAR(20),
 customer_key INT,
 product_key INT,
 date_key INT,
 quantity INT,
 revenue DECIMAL(12,2)
);

-- ============================================================
-- TASK 3 — Populate Dimensions
-- ============================================================

INSERT INTO dim_customer (customer_id, country, first_purchase_date)
SELECT
 customer_id,
 country,
 MIN(DATE(invoice_date))
FROM staging_sales_clean
GROUP BY customer_id, country;

INSERT INTO dim_product (stock_code, description)
SELECT DISTINCT
 stock_code,
 description
FROM staging_sales_clean;

INSERT INTO dim_date (full_date, year, month, week, weekday)
SELECT DISTINCT
 DATE(invoice_date),
 YEAR(invoice_date),
 MONTH(invoice_date),
 WEEK(invoice_date),
 DAYOFWEEK(invoice_date)
FROM staging_sales_clean;

-- ============================================================
-- TASK 4 — Add Indexes Before Fact Load
-- ============================================================

CREATE INDEX idx_stage_customer
ON staging_sales_clean(customer_id, country);

CREATE INDEX idx_stage_product
ON staging_sales_clean(stock_code);

CREATE INDEX idx_stage_date
ON staging_sales_clean(invoice_date);

CREATE INDEX idx_customer_business
ON dim_customer(customer_id, country);

CREATE INDEX idx_product_business
ON dim_product(stock_code);

CREATE INDEX idx_date_full
ON dim_date(full_date);

-- ============================================================
-- TASK 4 — Load Fact Table
-- ============================================================

TRUNCATE TABLE fact_sales;

INSERT INTO fact_sales (
 invoice_no,
 customer_key,
 product_key,
 date_key,
 quantity,
 revenue
)
SELECT
 s.invoice_no,
 c.customer_key,
 p.product_key,
 d.date_key,
 s.quantity,
 s.quantity * s.unit_price
FROM staging_sales_clean s
JOIN dim_customer c
  ON s.customer_id = c.customer_id
 AND s.country = c.country
JOIN dim_product p
  ON s.stock_code = p.stock_code
JOIN dim_date d
  ON DATE(s.invoice_date) = d.full_date;

-- ============================================================
-- TASK 5 — Foreign Keys + Performance Indexes
-- ============================================================

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_customer
FOREIGN KEY (customer_key)
REFERENCES dim_customer(customer_key),

ADD CONSTRAINT fk_fact_product
FOREIGN KEY (product_key)
REFERENCES dim_product(product_key),

ADD CONSTRAINT fk_fact_date
FOREIGN KEY (date_key)
REFERENCES dim_date(date_key);

CREATE INDEX idx_fact_customer ON fact_sales(customer_key);
CREATE INDEX idx_fact_product ON fact_sales(product_key);
CREATE INDEX idx_fact_date ON fact_sales(date_key);
CREATE INDEX idx_fact_invoice ON fact_sales(invoice_no);

CREATE INDEX idx_fact_customer_date
ON fact_sales(customer_key, date_key);
