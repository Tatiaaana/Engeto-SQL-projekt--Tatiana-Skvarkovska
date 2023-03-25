-- 3rd question
SELECT 
  t.food_name, 
  AVG(
    round(
      (
        t2.average_price - t.average_price
      )/ t.average_price * 100, 
      2
    )
  ) AS price_change 
FROM 
  t_tatiana_skvarkovska_project_sql_primary_final t 
  JOIN t_tatiana_skvarkovska_project_sql_primary_final t2 ON t.food_category = t2.food_category 
  AND t.`year` = t2.`year` - 1 
GROUP BY 
  food_name 
HAVING 
  price_change > 0 
ORDER BY 
  price_change 
LIMIT 
  1;