-- 1st question
SELECT 
  DISTINCT branch.name AS industry_name, 
  pay.payroll_year AS payroll_year, 
  AVG (pay.value) AS average_pay 
FROM 
  czechia_payroll pay 
  JOIN czechia_payroll_industry_branch branch ON pay.industry_branch_code = branch.code 
WHERE 
  pay.value_type_code = 5958 
  AND pay.value IS NOT NULL 
  AND pay.calculation_code = 100 
GROUP BY 
  branch.name, 
  pay.payroll_year 
ORDER BY 
  pay.industry_branch_code, 
  pay.payroll_year;
 
 -- 2nd question
SELECT 
  `year`, 
  food_name, 
  round(average_price, 2) AS average_price, 
  round(
    AVG(average_pay), 
    2
  ) AS average_pay, 
  round(
    AVG(average_pay)/ average_price
  ) AS amount 
FROM 
  t_tatiana_skvarkovska_project_sql_primary_final 
WHERE 
  food_category IN (111301, 114201) 
  AND `year` IN (2006, 2018) 
GROUP BY 
  `year`, 
  food_name;