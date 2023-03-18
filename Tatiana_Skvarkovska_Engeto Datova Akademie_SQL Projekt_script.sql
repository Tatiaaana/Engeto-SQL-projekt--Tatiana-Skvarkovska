-- QL Projekt Tatiana Škvarkovská - GitHub účet Tatiaaana

-- vytvorenie 1. tabuľky
CREATE TABLE IF NOT EXISTS t_Tatiana_Skvarkovska_project_SQL_primary_final AS 
SELECT 
  DISTINCT YEAR(cp.date_from) AS ROK, 
  AVG (cp.value) AS priemerna_cena, 
  cp.category_code, 
  (
    SELECT 
      DISTINCT AVG(cp3.value) 
    FROM 
      czechia_payroll cp3 
    WHERE 
      cp3.value_type_code = 5958 
      AND cp3.value IS NOT NULL 
      AND cp3.calculation_code = 100 
      AND cp3.payroll_year = ROK
  ) AS priemerna_mzda 
FROM 
  czechia_price cp 
  JOIN czechia_payroll cp2 ON YEAR(cp.date_from)= cp2.payroll_year 
GROUP BY 
  YEAR(cp.date_from), 
  cp.category_code, 
  cp2.payroll_year;
 
-- vytvorenie 2. tabuľky
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
  
  -- 1. hypotéza
 SELECT 
  DISTINCT cpib.name, 
  cp.payroll_year, 
  AVG (cp.value) AS priemerna_mzda 
FROM 
  czechia_payroll cp 
  JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code 
WHERE 
  cp.value_type_code = 5958 
  AND cp.value IS NOT NULL 
  AND cp.calculation_code = 100 
GROUP BY 
  cpib.name, 
  cp.payroll_year 
ORDER BY 
  cp.industry_branch_code, 
  cp.payroll_year;
 
 -- 2. hypotéza
 SELECT 
  ROK, 
  cpc.name AS nazov, 
  priemerna_cena, 
  priemerna_mzda, 
  round(priemerna_mzda / priemerna_cena) AS kupi_potravin 
FROM 
  t_Tatiana_Skvarkovska_project_SQL_primary_final t
  JOIN czechia_price_category cpc ON t.category_code = cpc.code 
WHERE 
  category_code IN (111301, 114201) 
  AND ROK IN(2006, 2018);
 
 -- 3. hypotéza 
 SELECT 
  cpc.name, 
  AVG (
    round(
      (
        t2.priemerna_cena - t.priemerna_cena
      )/ t.priemerna_cena * 100, 
      2
    )
  ) AS vyvoj_ceny_medzirocne 
FROM 
  t_Tatiana_Skvarkovska_project_SQL_primary_final t 
  JOIN t_Tatiana_Skvarkovska_project_SQL_primary_final t2 ON t.category_code = t2.category_code 
  AND t.ROK = t2.ROK - 1 
  JOIN czechia_price_category cpc ON t.category_code = cpc.code 
GROUP BY 
  cpc.name 
ORDER BY 
  vyvoj_ceny_medzirocne 
LIMIT 
  1;
 
 -- 4. hypotéza 
 SELECT 
  t2.ROK, 
  round(
    (
      t2.priemerna_cena - t.priemerna_cena
    )/ t.priemerna_cena * 100, 
    2
  ) AS vyvoj_ceny_medzirocne, 
  round(
    (
      t2.priemerna_mzda - t.priemerna_mzda
    )/ t.priemerna_mzda * 100, 
    2
  ) AS vyvoj_mzdy_medzirocne, 
  CASE WHEN (
    t2.priemerna_cena - t.priemerna_cena
  )/ t.priemerna_cena * 100 -(
    t2.priemerna_mzda - t.priemerna_mzda
  )/ t.priemerna_mzda * 100 > 10 THEN "ANO" ELSE "NIE" END vysoky_narast 
FROM 
  t_Tatiana_Skvarkovska_project_SQL_primary_final t 
  JOIN t_Tatiana_Skvarkovska_project_SQL_primary_final t2 ON t.category_code = t2.category_code 
  AND t.ROK = t2.ROK - 1 
  JOIN czechia_price_category cpc ON t.category_code = cpc.code 
GROUP BY 
  t.ROK 
ORDER BY 
  vysoky_narast ASC;

 
 -- 5. hypotéza 
SELECT 
  t.ROK, 
  t2.ROK AS nasledujuci_rok, 
  round(
    (
      t2.priemerna_cena - t.priemerna_cena
    )/ t.priemerna_cena * 100, 
    2
  ) AS vyvoj_cien_medzirocne, 
  round(
    (
      t2.priemerna_mzda - t.priemerna_mzda
    )/ t.priemerna_mzda * 100, 
    2
  ) AS vyvoj_miezd_medzirocne, 
  round(
    (e2.GDP - e.GDP)/ e.GDP * 100, 
    2
  ) AS vyvoj_HDP
FROM 
  t_Tatiana_Skvarkovska_project_SQL_primary_final t 
  JOIN economies e ON t.ROK = e.`year` 
  JOIN economies e2 ON t.ROK = e2.`year` - 1 
  JOIN t_Tatiana_Skvarkovska_project_SQL_primary_final t2 ON t.category_code = t2.category_code 
  AND t.ROK = t2.ROK - 1 
WHERE 
  e.country = "Czech Republic" 
  AND e2.country = "Czech Republic" 
GROUP BY 
  t.ROK;

 
 