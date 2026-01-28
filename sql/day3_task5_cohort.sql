USE consumer360;

DROP TABLE IF EXISTS mart_cohort_monthly;

CREATE TABLE mart_cohort_monthly AS
SELECT
 DATE_FORMAT(c.first_purchase_date, '%Y-%m') AS cohort_month,
 DATE_FORMAT(d.full_date, '%Y-%m') AS order_month,

 COUNT(DISTINCT f.customer_key) AS active_customers,
 SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_customer c
  ON f.customer_key = c.customer_key
JOIN dim_date d
  ON f.date_key = d.date_key
GROUP BY cohort_month, order_month;
