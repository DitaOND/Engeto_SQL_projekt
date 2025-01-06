#3Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

#kontrola dat
SELECT *
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 

#zjistíme, jak staré mámme údaje: 2006-2018

SELECT MIN(year), MAX (year)
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 



SELECT 
a.category_name, 
a.average_price AS average_price_2006, 
b.average_price AS average_price_2018,
(b.average_price-a.average_price) AS diff,
ROUND((b.average_price-a.average_price)*100/a.average_price,2) AS diff_perc
FROM
(SELECT DISTINCT (average_price),category_name
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
WHERE YEAR=2006) a
LEFT JOIN
(SELECT DISTINCT(average_price),category_name
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
WHERE YEAR=2018) b
ON a.category_name=b.category_name
ORDER BY (b.average_price-a.average_price)/a.average_price ASC 


#porovnání za 3 roky -v kategoriích je navíc jedna, která začíná až 2015, tak ji přidáme

SELECT 
a.category_name, 
c.average_price AS average_price_2006, 
b.average_price AS average_price_2015,
a.average_price AS average_price_2018,
ROUND((a.average_price-c.average_price)*100/c.average_price,2) AS MAIN_diff_2018_to_2006,
ROUND((a.average_price-b.average_price)*100/b.average_price,2) AS diff2018_to_2015
FROM
(SELECT DISTINCT (average_price),category_name
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
WHERE YEAR=2018) a
LEFT JOIN
(SELECT DISTINCT(average_price),category_name
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
WHERE YEAR=2015) b
ON a.category_name=b.category_name
LEFT JOIN
(SELECT DISTINCT(average_price),category_name
FROM t_Dita_Ondruchova_project_SQL_primary_final tdopspf 
WHERE YEAR=2006) c
ON a.category_name=c.category_name
ORDER BY (a.average_price-c.average_price)/c.average_price ASC 