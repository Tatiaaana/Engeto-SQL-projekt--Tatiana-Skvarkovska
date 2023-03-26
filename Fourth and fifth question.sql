-- 4th question
SELECT 
  t2.`year`, 
  round(
    (
      AVG(t2.average_price)- AVG(t.average_price)
    )/ AVG(t.average_price) * 100, 
    2
  ) AS price_change, 
  round(
    (
      AVG(t2.average_pay) - AVG(t.average_pay)
    )/ AVG(t.average_pay) * 100, 
    2
  ) AS pay_change, 
  CASE WHEN (
    AVG(t2.average_price)- AVG(t.average_price)
  )/ AVG(t.average_price) * 100 - (
    AVG(t2.average_pay)- AVG(t.average_pay)
  )/ AVG(t.average_pay) * 100 > 10 THEN "YES" ELSE "NO" END high_growth 
FROM 
  t_tatiana_skvarkovska_project_sql_primary_final t 
  JOIN t_tatiana_skvarkovska_project_sql_primary_final t2 ON t.food_category = t2.food_category 
  AND t.`year` = t2.`year` - 1 
GROUP BY 
  t.`year`;
  
 -- 5th question
 SELECT 
  t2.`year`, 
  round(
    (
      AVG(t2.average_price)- AVG(t.average_price)
    )/ AVG(t.average_price) * 100, 
    2
  ) AS price_change, 
  round(
    (
      AVG(t2.average_pay) - AVG(t.average_pay)
    )/ AVG(t.average_pay) * 100, 
    2
  ) AS pay_change, 
  round(
    (e2.GDP - e.GDP)/ e.GDP * 100, 
    2
  ) AS GDP_change 
FROM 
  t_tatiana_skvarkovska_project_sql_primary_final t 
  JOIN economies e ON t.`year` = e.`year` 
  JOIN economies e2 ON t.`year` = e2.`year` - 1 
  JOIN t_tatiana_skvarkovska_project_sql_primary_final t2 ON t.food_category = t2.food_category 
  AND t.`year` = t2.`year` - 1 
WHERE 
  e.country = "Czech Republic" 
  AND e2.country = "Czech Republic" 
GROUP BY 
  t.`year`;
