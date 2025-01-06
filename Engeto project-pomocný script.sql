
#view s průmernými cenami, kde je region null, region nebudeme potřebovat k analýze
----TABULKA 1 - ceny

SELECT 
YEAR(cp.date_from),
cp.value AS average_price, 
cp.category_code, 
cpc.name, 
cpc.price_value, 
cpc.price_unit
FROM czechia_price cp 
LEFT JOIN czechia_price_category cpc 
ON cp.category_code = cpc.code
WHERE cp.region_code IS NULL 
ORDER BY YEAR(cp.date_from)

--TABULKA 2- mzdy
#pokud je industry branch code NULL -jedná se o průmer na celý rok, ale nesedí k výpočtum, tak si spočtu vlastní průmer

SELECT cpay.payroll_year, AVG(cpay.value) AS average_wage, cpay.industry_branch_code, cpib.name AS industry_name
FROM czechia_payroll cpay
JOIN czechia_payroll_industry_branch cpib 
ON cpay.industry_branch_code = cpib.code
WHERE cpay.calculation_code = 200 AND value_type_code =5958 AND industry_branch_code IS NOT NULL
GROUP BY cpay.payroll_year, cpay.industry_branch_code 




#výsledná tabulka - spojuje informace czechia price a czechia payroll, tak aby žádné hodnoty nebyly vynechány + napojené popisky kategorií


CREATE TABLE t_Dita_Ondruchova_project_SQL_primary_final AS
SELECT 
YEAR(cp.date_from) AS YEAR,
cp.value AS average_price, 
cp.category_code, 
cpc.name AS category_name,
cpc.price_value, 
cpc.price_unit, 
cpay.payroll_year, 
AVG(cpay.value) AS average_wage, 
cpay.industry_branch_code,
cpib.name AS industry_name
FROM czechia_price cp 
LEFT JOIN czechia_payroll cpay
ON YEAR(cp.date_from) = cpay.payroll_year 
LEFT JOIN czechia_price_category cpc 
ON cp.category_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch cpib 
ON cpay.industry_branch_code = cpib.code
WHERE cp.region_code IS NULL AND cpay.calculation_code = 200 AND value_type_code =5958 AND industry_branch_code IS NOT NULL
GROUP BY cp.category_code, cpay.payroll_year, cpay.industry_branch_code
UNION
SELECT
YEAR(cp.date_from) AS YEAR,
cp.value AS average_price, 
cp.category_code, 
cpc.name AS category_name, 
cpc.price_value, 
cpc.price_unit, 
cpay.payroll_year, 
AVG(cpay.value) AS average_wage, 
cpay.industry_branch_code,
cpib.name AS industry_name
FROM czechia_price cp 
RIGHT JOIN czechia_payroll cpay
ON YEAR(cp.date_from) = cpay.payroll_year 
LEFT JOIN czechia_price_category cpc 
ON cp.category_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch cpib 
ON cpay.industry_branch_code = cpib.code
WHERE cp.region_code IS NULL AND cpay.calculation_code = 200 AND value_type_code =5958 AND industry_branch_code IS NOT NULL
GROUP BY cp.category_code, cpay.payroll_year, cpay.industry_branch_code;


#kontrola
SELECT *
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 

SELECT COUNT(*)
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
