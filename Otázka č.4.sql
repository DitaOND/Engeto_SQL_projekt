##Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

SELECT *
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 


#průměrné mzdy
SELECT payroll_year , average_wage 
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
GROUP BY payroll_year 


   #procentní nárůst mezd v letech
   SELECT 
    payroll_year, 
    AVG(average_wage) AS average_wage,
    ROUND(((AVG(average_wage) - LAG(AVG(average_wage)) OVER (ORDER BY payroll_year)) / LAG(AVG(average_wage)) OVER (ORDER BY payroll_year)) * 100,2) AS wage_increase_percent
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf
GROUP BY payroll_year
ORDER BY payroll_year;


#průměrná cena potravin rok
SELECT 
year, 
AVG(average_price) AS average_price,
ROUND(((AVG(average_price) - LAG(AVG(average_price)) OVER (ORDER BY year)) / LAG(AVG(average_price)) OVER (ORDER BY year)) * 100,2) AS prices_increase_percent
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
GROUP BY year


#výsledná tabulka:
SELECT 
a.year, 
ROUND(AVG(a.average_price),2) AS average_price,
ROUND(AVG(b.average_wage),0) AS average_wage,
ROUND(((AVG(a.average_price) - LAG(AVG(a.average_price)) OVER (ORDER BY a.year)) / LAG(AVG(a.average_price)) OVER (ORDER BY a.year)) * 100,2) AS prices_increase_percent,
ROUND(((AVG(b.average_wage) - LAG(AVG(b.average_wage)) OVER (ORDER BY b.payroll_year)) / LAG(AVG(b.average_wage)) OVER (ORDER BY b.payroll_year)) * 100,2) AS wage_increase_percent,
prices_increase_percent-wage_increase_percent AS diff_price_wages, 
CASE 
	WHEN (prices_increase_percent-wage_increase_percent) >10 THEN 'prices increased by more than 10% compared to wages'
	WHEN (prices_increase_percent-wage_increase_percent) >5 THEN 'prices increased by 5-10% compared to wages'
	WHEN (prices_increase_percent-wage_increase_percent) >0 THEN 'prices increased by more than 0-5% compared to wages'
	WHEN (prices_increase_percent-wage_increase_percent) IS NULL THEN 'not relevant'
	ELSE 'wages increased more than prices%'
END AS Comparision
FROM 
(SELECT 
year, 
AVG(average_price) AS average_price,
ROUND(((AVG(average_price) - LAG(AVG(average_price)) OVER (ORDER BY year)) / LAG(AVG(average_price)) OVER (ORDER BY year)) * 100,2) AS prices_increase_percent
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf
GROUP BY year) a
JOIN
(SELECT 
    payroll_year, 
    AVG(average_wage) AS average_wage,
    ROUND(((AVG(average_wage) - LAG(AVG(average_wage)) OVER (ORDER BY payroll_year)) / LAG(AVG(average_wage)) OVER (ORDER BY payroll_year)) * 100,2) AS wage_increase_percent
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf
GROUP BY payroll_year) b
ON a.year=b.payroll_year
GROUP BY payroll_year

