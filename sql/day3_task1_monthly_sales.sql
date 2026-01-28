USE consumer360;

DROP TABLE IF EXISTS mart_monthly_sales;

CREATE TABLE mart_monthly_sales AS
SELECT
 d.year,
 d.month,
 SUM(f.revenue) AS total_revenue,
 SUM(f.quantity) AS total_units,
 COUNT(DISTINCT f.invoice_no) AS invoices
FROM fact_sales f
JOIN dim_date d
  ON f.date_key = d.date_key
GROUP BY d.year, d.month;

SELECT COUNT(*) FROM mart_monthly_sales;

SELECT * FROM mart_monthly_sales LIMIT 10;
