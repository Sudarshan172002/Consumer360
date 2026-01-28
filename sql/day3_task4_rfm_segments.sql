USE consumer360;

DROP TABLE IF EXISTS mart_customer_segments;

CREATE TABLE mart_customer_segments AS
SELECT
 *,
 CONCAT(r_score, f_score, m_score) AS rfm_cell,
 CASE
   WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
     THEN 'Champion'
   WHEN r_score >= 4 AND f_score >= 3
     THEN 'Loyal'
   WHEN r_score = 5 AND f_score <= 2
     THEN 'New Customers'
   WHEN r_score <= 2 AND f_score >= 4
     THEN 'At Risk'
   WHEN r_score = 1 AND f_score = 1
     THEN 'Lost'
   ELSE 'Regular'
 END AS segment
FROM mart_customer_rfm_scored;

SELECT segment, COUNT(*)
FROM mart_customer_segments
GROUP BY segment
ORDER BY COUNT(*) DESC;

