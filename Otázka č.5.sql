# Má výška HDP vliv na změny ve mzdách a cenách potravin? 
#Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?


#kontrola dat ve zdroji
SELECT *
FROM economies e 
WHERE country ='Czech Republic' AND YEAR >=2006
ORDER BY year 


SELECT e.country, year, ROUND (e.GDP/1000000000, 2) AS GDP_in_mld
FROM economies e 
WHERE country ='Czech Republic' AND year >=2006
ORDER BY year 


#vytvoření pomocné tabulky
CREATE TABLE t_Dita_Ondruchova_project_SQL_secondary_final AS
SELECT 
e.country, 
e.year, 
ROUND(e.GDP / 1000000000, 2) AS GDP_in_mld,
ROUND(((e.GDP - LAG(e.GDP) OVER (ORDER BY year)) / LAG(e.GDP) OVER (ORDER BY year)) * 100, 2) AS GDP_increase_percent
FROM     economies e 
WHERE     e.country = 'Czech Republic' AND e.year >= 2006
ORDER BY e.year;


#kontrola vytvořené tabulky
SELECT *
FROM t_Dita_Ondruchova_project_SQL_secondary_final 

#Výsledná script (kopie č.4 1 GDP)

SELECT 
a.year, 
ROUND(AVG(a.average_price),2) AS average_price,
ROUND(AVG(b.average_wage),0) AS average_wage,
ROUND(((AVG(a.average_price) - LAG(AVG(a.average_price)) OVER (ORDER BY a.year)) / LAG(AVG(a.average_price)) OVER (ORDER BY a.year)) * 100,2) AS prices_increase_percent,
ROUND(((AVG(b.average_wage) - LAG(AVG(b.average_wage)) OVER (ORDER BY b.payroll_year)) / LAG(AVG(b.average_wage)) OVER (ORDER BY b.payroll_year)) * 100,2) AS wage_increase_percent,
prices_increase_percent-wage_increase_percent AS diff_price_wages, 
tdopssf.GDP_in_mld, 
tdopssf.GDP_increase_percent
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
JOIN t_Dita_Ondruchova_project_SQL_secondary_final tdopssf
ON a.year=tdopssf.year
GROUP BY payroll_year
