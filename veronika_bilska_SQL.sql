/* 
---------------------------------------------------------------------------------------------------------------------------------------
[ ==> Primární tabulka - pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky ]
---------------------------------------------------------------------------------------------------------------------------------------
*/
 
CREATE TABLE t_veronika_bilska_project_SQL_primary_final AS
SELECT 
	cpc.name AS food_category,
	cp.value AS price,
	cpay.payroll_year,
	cpay.value AS avg_wages,
	cpib.name AS industry_branch
FROM czechia_price cp
JOIN czechia_payroll cpay 
	ON YEAR(cp.date_from) = cpay.payroll_year AND cp.region_code IS NULL AND cpay.value_type_code = 5958
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib 
	ON cpay.industry_branch_code = cpib.code;

/* 
-----------------------------------------------------------------------------
[  ==> Sekundární tabulka - pro dodatečná data o dalších evropských státech ]
-----------------------------------------------------------------------------
*/

CREATE TABLE t_veronika_bilska_project_SQL_secondary_final AS 
SELECT 
	c.country,
	e.`year` as my_year,
	e.population, 
	e.gini,
	e.GDP	
FROM countries c
JOIN economies e ON c.country = e.country
	WHERE c.continent = 'Europe'AND e.`year` BETWEEN 2006 AND 2018
ORDER BY c.country, my_year;

select * from t_veronika_bilska_project_sql_primary_final tvbpspf 

/* 
* -------------------------------------------------------------------------------------------
* [  ==> OTÁZKA 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? ]
* -------------------------------------------------------------------------------------------
*/

-- view 1 - odvětví, rok, průměrná mzda
CREATE VIEW v_temp_veronika_bilska_project_SQL_data_01 AS 
SELECT 
	industry_branch,
	payroll_year,
	round(avg(avg_wages)) AS avg_wages
FROM t_veronika_bilska_project_SQL_primary_final 
GROUP BY industry_branch, payroll_year
ORDER BY industry_branch;

-- view 2 - pohyb mezd - odvětví a rok
CREATE VIEW v_temp_veronika_bilska_project_SQL_data_02 AS
SELECT
	new_table.industry_branch, 
	old_table.payroll_year AS prev_year,
	new_table.payroll_year AS new_year,
	old_table.avg_wages AS prev_wages,
	new_table.avg_wages AS new_wages,
	new_table.avg_wages - old_table.avg_wages AS wages_gap,
	round((new_table.avg_wages - old_table.avg_wages)/old_table.avg_wages * 100, 2) AS wages_gap_percent,
	CASE
		WHEN new_table.avg_wages > old_table.avg_wages
			THEN 1
			ELSE 0
	END AS wages_change
FROM v_temp_veronika_bilska_project_SQL_data_01 AS new_table
JOIN v_temp_veronika_bilska_project_SQL_data_01 AS old_table
	ON new_table.industry_branch = old_table.industry_branch
	AND new_table.payroll_year = old_table.payroll_year + 1
ORDER BY industry_branch, prev_year



-- souhrn odvětví s označením zda-li mzdy meziročně stále rostou (1) či někdy také klesají (0)
SELECT industry_branch , min(wages_change) as still_increasing 
FROM v_temp_veronika_bilska_project_sql_data_02
GROUP BY industry_branch 
ORDER BY still_increasing;


-- seznam odvětví seřazen vzestupně podle nejnižšího po nejvyšší procentuální rozdíl mezd mezi léty 2006 a 2018
SELECT 
	industry_branch, 
	min(avg_wages) as 2006_wages, 
	max(avg_wages) as 2018_wages, 
	max(avg_wages) - min(avg_wages) as gap, 
	round((max(avg_wages) - min(avg_wages))/min(avg_wages) *100,1) as gap_percent
FROM v_temp_veronika_bilska_project_sql_data_01 
WHERE payroll_year IN (2006, 2018)
GROUP BY industry_branch 
ORDER BY gap_percent;

/* Mzdy v průběhu let rostou ve všech odvětvích, avšak u většiny sledovaných meziročně také klesaly. 
 * Nejvyšší nárust ve sledovaném období zaznamenal obor zdravotní a sociální péče kde se mzdy navýšily až o 76,9% */



/* 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* [  ==> OTÁZKA 2 - Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?? ]
* ---------------------------------------------------------------------------------------------------------------------------------------------------
*/


SELECT
	food_category , 
	payroll_year , 
	ROUND(AVG(price), 2) AS average_price,
	ROUND(AVG(avg_wages), 2) AS average_wages,
	ROUND(AVG(avg_wages) / AVG(price),0) AS avg_QTY_purchased
FROM t_veronika_bilska_project_SQL_primary_final
WHERE payroll_year IN(2006, 2018)
	AND food_category IN('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
GROUP BY food_category , payroll_year 
ORDER BY food_category, payroll_year;

/* Na začátku sledovaného období, v roce 2006, bylo možno za průměrnou mzdu 20.754 Kč zakoupit 1287 kg chleba a 1437 litrů mléka. 
 * Naopak na konci sledovaného období, v roce 2018, bylo již možno za průměrnou mzdu 32.536,- Kč zakoupit o 55 kg chleba a 205 litrů mléka více, 
 * přesněji 1342 ks chleba a 1642 litrů mléka */


/* 
* -------------------------------------------------------------------------------------------------------------------
* [  ==> OTÁZKA 3 - Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? ]
* -------------------------------------------------------------------------------------------------------------------
*/


-- view 3 - kategorie, rok, průměrná cena
CREATE VIEW v_temp_veronika_bilska_project_SQL_data_03 AS 
SELECT DISTINCT 
	food_category, 
	payroll_year AS my_year, 
	round(avg(price), 2) AS avg_price
FROM t_veronika_bilska_project_SQL_primary_final
GROUP BY food_category, payroll_year;


-- view 4 - pohyb cen potravin - název kategorie, roky, ceny, rozdíly
CREATE VIEW v_temp_veronika_bilska_project_SQL_data_04 AS 
SELECT DISTINCT 
	old_table.food_category, 
	old_table.my_year AS prev_year,
	old_table.avg_price AS prev_price,
	new_table.my_year AS new_year,
	new_table.avg_price AS new_price, 
	new_table.avg_price - old_table.avg_price AS price_gap,
	round((new_table.avg_price - old_table.avg_price) / old_table.avg_price * 100, 2) AS price_gap_percent
FROM v_temp_veronika_bilska_project_SQL_data_03 AS old_table
JOIN v_temp_veronika_bilska_project_SQL_data_03 AS new_table 
	ON old_table.food_category = new_table.food_category AND new_table.my_year = old_table.my_year +1
ORDER BY food_category, old_table.my_year;

-- seznam kategorií potravin seřazen vzestupně od nejnižšího po nejvyšší procentuální cenový rozdíl mezi léty 2006 a 2018
SELECT 
	min(prev_year) AS year_from,
	max(new_year) AS year_to,
	food_category,
	round(avg(price_gap_percent), 2) AS avg_diff_price_percent
FROM v_temp_veronika_bilska_project_sql_data_04
GROUP BY food_category
ORDER BY round(avg(price_gap_percent), 2);


/* Nejnižší meziroční cenový "nárust" je u banánu, kde průměrné procentuální navýšení ceny od roku 2006 do roku 2018 dosáhlo 0.81%. 
 * Existují také potraviny, kde celkový průměrný pohyb ceny klesnul do mínusových hodnot, což znamená, že daná kategorie v průběhu let zlevnila - 
 * například cukr krystal má průměrnou hodnotu -1,92% nebo rajská jablka s hodnotou -0,74% 
 */


/* 
* ----------------------------------------------------------------------------------------------------------------------------
* [  ==> OTÁZKA 4 - Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?? ]
* ----------------------------------------------------------------------------------------------------------------------------
*/


-- view 5 - průměry platů ze všech odvětví dohromady pro každý sledovaný rok
CREATE VIEW v_temp_veronika_bilska_project_SQL_data_05 AS 
SELECT 
	payroll_year, 
	round(avg(avg_wages)) AS avg_wages_all_branch
FROM v_temp_veronika_bilska_project_sql_data_01 
GROUP BY payroll_year
ORDER BY payroll_year;



-- view 6 - vývoj platů ze všech odvětví dohromady pro každý sledovaný rok
CREATE VIEW v_temp_veronika_bilska_project_SQL_data_06 AS 
SELECT
	old_table.payroll_year AS old_year, 
	old_table.avg_wages_all_branch AS old_wages,
	new_table.payroll_year AS new_year,
	new_table.avg_wages_all_branch AS new_wages,
	round((new_table.avg_wages_all_branch - old_table.avg_wages_all_branch) / old_table.avg_wages_all_branch * 100, 2) AS avg_wages_gap_percent
FROM v_temp_veronika_bilska_project_SQL_data_05 AS old_table
JOIN v_temp_veronika_bilska_project_SQL_data_05 AS new_table
	ON new_table.payroll_year = old_table.payroll_year + 1
ORDER BY old_year;



-- view 7 - průměry cen všech kategorií potravin dohromady pro každý sledovaný rok
CREATE VIEW v_temp_veronika_bilska_project_SQL_data_07 AS 
SELECT 
	my_year,
	round(avg(avg_price), 2) AS avg_food_price_all_cat
FROM v_temp_veronika_bilska_project_SQL_data_03
GROUP BY my_year
ORDER BY my_year;


-- view 8 - vývoj cen všech kategorií potravin dohromady pro každý sledovaný rok
CREATE VIEW v_temp_veronika_bilska_project_SQL_data_08 AS 
SELECT
	old_table.my_year AS old_year, 
	old_table.avg_food_price_all_cat AS old_price,
	new_table.my_year AS new_year,
	new_table.avg_food_price_all_cat AS new_price,
	round((new_table.avg_food_price_all_cat - old_table.avg_food_price_all_cat) / old_table.avg_food_price_all_cat * 100, 2) AS avg_price_gap_percent
FROM v_temp_veronika_bilska_project_SQL_data_07 AS old_table
JOIN v_temp_veronika_bilska_project_SQL_data_07 AS new_table
	ON new_table.my_year = old_table.my_year + 1
ORDER BY old_year;


-- vývoj cen všech kategorií potravin a všech platů ze všech odvětví dohromady pro každý sledovaný rok
SELECT 
	prtr.old_year,
	wgtr.new_year, 
	wgtr.avg_wages_gap_percent,
	prtr.avg_price_gap_percent,
	prtr.avg_price_gap_percent - wgtr.avg_wages_gap_percent AS price_wages_gap
FROM v_temp_veronika_bilska_project_SQL_data_08 AS prtr
JOIN v_temp_veronika_bilska_project_SQL_data_06 AS wgtr 
	ON wgtr.old_year = prtr.old_year
ORDER BY old_year

/* Nejvyšší rozdíl růstu cen potravin v porovnání s růstem platů byl v roce 2013, kdy platy klesly oproti předchozímu roku o 1,56% narozdíl od cen potravin, které vzrostly
 * oproti předchozímu roku o 5,1%. Celkový rozdíl tedy činí 6,66%. 
 * V žádném roce platy ani ceny potravin nepřesáhly meziroční rozdíl vyšší nebo roven 10%. 
 */



/* 
* -----------------------------------------------------------------------------------------------------------------------------
* [  ==> OTÁZKA 5 - Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, ]
* [  projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?                            ]
* -----------------------------------------------------------------------------------------------------------------------------
*/


-- view 9 - vývoj GDP pro každý sledovaný rok
CREATE VIEW v_temp_veronika_bilska_project_SQL_data_09 AS 
SELECT
	old_table.my_year AS old_year, 
	old_table.gdp AS old_gdp,
	new_table.my_year AS new_year,
	new_table.gdp AS new_gdp,
	round((new_table.gdp - old_table.gdp) / old_table.gdp * 100, 2) AS avg_gdp_gap_percent
FROM (SELECT * FROM t_veronika_bilska_project_SQL_secondary_final WHERE country = 'Czech Republic') AS old_table
JOIN (SELECT * FROM t_veronika_bilska_project_SQL_secondary_final WHERE country = 'Czech Republic') AS new_table
	ON new_table.my_year = old_table.my_year + 1
ORDER BY old_year;


-- vývoj cen všech kategorií potravin, všech platů a všech HDP pro každý sledovaný rok
SELECT 
	gdp.old_year as from_year, 
	gdp.new_year as to_year, 
	price.avg_price_gap_percent AS food_price_trend,
	wages.avg_wages_gap_percent AS wages_trend, 
	gdp.avg_gdp_gap_percent AS GDP_trend
FROM v_temp_veronika_bilska_project_SQL_data_09 AS gdp
JOIN v_temp_veronika_bilska_project_SQL_data_06 AS wages
	ON wages.old_year = gdp.old_year
JOIN v_temp_veronika_bilska_project_SQL_data_08 AS price
	ON price.old_year = gdp.old_year
ORDER BY from_year;

/* Z výsledné tabulky je patrné, že růst HDP nemá vždy přímo vliv na růst cen potravin či platů v ČR. 
 * Například v roce 2015 se zvýšilo HDP o 5,39% a ceny potravin ve stejném roce i následujícím klesaly. 
 * Nelze tedy s jistotou potvrdit ani vyvrátit, že existuje přímá závislost HDP na ceny potravin a platů. 
 */



