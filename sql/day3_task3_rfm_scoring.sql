USE consumer360;

DROP TABLE IF EXISTS mart_customer_rfm_scored;

CREATE TABLE mart_customer_rfm_scored AS
SELECT
 *,
 NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
 NTILE(5) OVER (ORDER BY frequency) AS f_score,
 NTILE(5) OVER (ORDER BY monetary) AS m_score
FROM mart_customer_rfm;

SELECT r_score, COUNT(*)
FROM mart_customer_rfm_scored
GROUP BY r_score
ORDER BY r_score;

SELECT f_score, COUNT(*)
FROM mart_customer_rfm_scored
GROUP BY f_score
ORDER BY f_score;

SELECT m_score, COUNT(*)
FROM mart_customer_rfm_scored
GROUP BY m_score
ORDER BY m_score;



