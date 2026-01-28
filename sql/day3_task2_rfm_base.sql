USE consumer360;

DROP TABLE IF EXISTS mart_customer_rfm;

CREATE TABLE mart_customer_rfm AS
WITH latest_date AS (
    SELECT MAX(d.full_date) AS max_date
    FROM fact_sales f
    JOIN dim_date d
      ON f.date_key = d.date_key
)
SELECT
 c.customer_key,
 c.customer_id,

 DATEDIFF(
   (SELECT max_date FROM latest_date),
   MAX(d.full_date)
 ) AS recency_days,

 COUNT(DISTINCT f.invoice_no) AS frequency,

 SUM(f.revenue) AS monetary
FROM fact_sales f
JOIN dim_customer c
  ON f.customer_key = c.customer_key
JOIN dim_date d
  ON f.date_key = d.date_key
GROUP BY c.customer_key, c.customer_id;
SELECT *
FROM mart_customer_rfm
ORDER BY monetary DESC
LIMIT 10;
