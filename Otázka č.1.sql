#Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- Porovnání průměrných mezd v letech 2000 a 2021 ukazuje nárůst mezd ve všech sledovaných odvětvích, tabulka je seřazena dle procentního nárůstu od nejvetšího k nejmenšímu 



#kontrola dat v tabulce
SELECT *
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 


#zjistím první a poslední rok, za který máme data o mzdách
SELECT MIN(payroll_year), MAX(payroll_year)
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 


SELECT a.industry_branch_code,a.industry_name, a.wage_2000, b.wage_2021, 
b.wage_2021-a.wage_2000 AS wage_difference,
ROUND((b.wage_2021-a.wage_2000)/a.wage_2000 *100,2) AS percentage_difference,
CASE 
	WHEN (b.wage_2021-a.wage_2000) >0 THEN 'increase' 
	ELSE 'decrease'
END AS 'wage changes -2021 compared to 2000'
FROM
(SELECT payroll_year, ROUND(average_wage,0) as wage_2000, industry_branch_code, industry_name
from t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
WHERE industry_branch_code IS NOT NULL AND payroll_year= 2000) a
JOIN 
(SELECT payroll_year, ROUND(average_wage,0) AS wage_2021, industry_branch_code
from t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
WHERE industry_branch_code IS NOT NULL AND payroll_year= 2021) b
ON a.industry_branch_code=b.industry_branch_code
GROUP BY a.industry_branch_code
ORDER BY percentage_difference DESC


