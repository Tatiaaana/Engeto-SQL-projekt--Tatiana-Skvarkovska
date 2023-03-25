-- first table

CREATE TABLE IF NOT EXISTS t_Tatiana_Skvarkovska_project_SQL_primary_final AS 
SELECT 
  DISTINCT YEAR(price.date_from) AS `year`, 
  price.category_code AS food_category, 
  cpc.name AS food_name, 
  AVG (price.value) AS average_price, 
  branch.name AS branch, 
  AVG(pay.value) AS average_pay 
FROM 
  czechia_price price 
  JOIN czechia_payroll pay ON YEAR(price.date_from)= pay.payroll_year 
  JOIN czechia_price_category cpc ON price.category_code = cpc.code 
  JOIN czechia_payroll_industry_branch branch ON pay.industry_branch_code = branch.code 
WHERE 
  pay.value IS NOT NULL 
  AND pay.industry_branch_code IS NOT NULL 
  AND pay.value_type_code = 5958 
  AND pay.calculation_code = 100 
GROUP BY 
  `year`, 
  food_category, 
  branch;
 
 
 -- second table
CREATE TABLE IF NOT EXISTS t_tatiana_skvarkovska_project_SQL_secondary_final AS 
SELECT 
  c.country, 
  e.year, 
  e.GDP, 
  c.capital_city, 
  c.currency_name, 
  c.currency_code, 
  c.religion, 
  c.government_type, 
  e.population, 
  e.taxes, 
  e.fertility, 
  e.mortaliy_under5 
FROM 
  countries c 
  JOIN economies e ON c.country = e.country 
WHERE 
  c.continent = "Europe" 
  AND GDP IS NOT NULL;
