#2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?						

SELECT *
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 

---zjistíme, jak staré mámme údaje: 2006-2018
SELECT MIN(year), MAX(year)
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
WHERE category_name LIKE'%Mléko%' OR category_name LIKE'%Chléb%'


---finální script

SELECT 
year, 
category_name, 
AVG(average_price), 
price_value, 
price_unit, 
ROUND(AVG(average_wage),0),
ROUND(AVG(average_wage)/AVG(average_price),0) AS count
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
WHERE year IN (2006,2018) 
AND (category_name LIKE '%Mléko%' OR category_name LIKE 'Chléb%')
GROUP BY  category_name, year

