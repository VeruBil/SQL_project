# SQL_project_result
# ------------------

# Porovnání dostupnosti potravin na základě průměrných příjmů

Pomocí SQL nástroje byly dle zadání analyzovány data o cenách potravin a růstu průměrných mezd napříč všemi odvětvími. V souvisejícím SQL scriptu byly posuzovány léta v rozmezí: 2006 -2018. Údaje o mzdách sice lze vyhledat v poskytnutých datových sadách v rozmezí let: 2000 -2021, nicméně datové sady, pomocí kterých lze sledovat vývoj cen potravin shromažďují údaje pouze za léta: 2006 – 2018.
Jako první krok,  při hledání odpovědí na otázky výzkumu, musely být vytvořeny dvě tabulky – primární tabulka, která shromažďuje data o mzdách a cenách potravin za posuzované období (2006 – 2018). Další sekundární tabulka  dále doplňuje dodatečná data o dalších evropských státech.

# Shrnutí otázek a následných odpovědí:

#OTÁZKA 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Mzdy v průběhu let rostou ve všech odvětvích, avšak u většiny sledovaných meziročně také klesaly. Nejvyšší nárůst ve sledovaném období zaznamenal obor zdravotní a sociální péče kde se mzdy navýšily až o 76,9% .
K výsledku bylo nezbytné vytvořit jako první dva následující náhledy. První náhled zobrazuje informaci o průměrné výši měsíční mzdy v jednotlivých odvětvích v letech: 2006-2018. Druhý náhled již zobrazuje meziroční srovnání mezd v posuzovaných letech – nechybí zde stěžejní procentuální vyjádření rozdílů mezd mezi jednotlivými roky. Z následující náhledů bylo nejdříve definováno, ve kterých odvětvích mzdy rostou a ve kterých naopak klesají. Dále byl vytvořený seznam odvětví, který byl seřazen vzestupně podle procentuálního rozdílu výše mezd v posuzovaných letech.

#OTÁZKA 2 - Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Na začátku sledovaného období, v roce 2006, bylo možno za průměrnou mzdu 20.754 Kč zakoupit 1287 kg chleba a 1437 litrů mléka.  Naopak na konci sledovaného období, v roce 2018, bylo již možno za průměrnou mzdu 32.536 Kč zakoupit o 55 kg chleba a 205 litrů mléka více,  přesněji 1342 ks chleba a 1642 litrů mléka.
Tyto hodnoty byl získány z primární tabulky, která byla vytvořená úplně v prvním kroku tohoto projektu. 

#OTÁZKA 3 - Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst?
Nejnižší meziroční cenový "nárůst" je u banánu, kde průměrné procentuální navýšení ceny (zdražení) od roku 2006 do roku 2018 dosáhlo 0.81%.
Existují také potraviny, kde celkový průměrný pohyb ceny klesnul do mínusových hodnot, což znamená, že daná kategorie v průběhu let zlevnila - například cukr krystal má průměrnou hodnotu -1,92% nebo rajská jablka s hodnotou -0,74%.
Při zjišťování této odpovědi opět musely být nejdříve vytvořeny dva náhledy – jeden, který zobrazuje data o kategoriích potravin a průměrné mzdě v jednotlivých letech. Ve druhém náhledu je zase zobrazený přehled o pohybu cen potravin -  kromě kategorie, posuzovaném roku a ceně, zde nechybí údaj o meziročním rozdílu.
Následně byl vygenerován seznam kategorií potravin, který byl seřazen vzestupně od nejnižšího po nejvyšší procentuální cenový rozdíl mezi léty 2006 a 2018.

#OTÁZKA 4 - Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Nejvyšší rozdíl růstu cen potravin v porovnání s růstem platů byl v roce 2013, kdy platy klesly oproti předchozímu roku o 1,56% narozdíl od cen potravin, které vzrostly oproti předchozímu roku o 5,1%. Celkový rozdíl tedy činí 6,66%.
V žádném roce platy ani ceny potravin nepřesáhly meziroční rozdíl vyšší nebo roven 10%.
V této části byly vytvořeny další potřebné náhledy: první zobrazuje průměrné platy ve všech odvětvích dohromady v jednotlivých letech. Druhý náhled zobrazuje vývoj mezd v každém sledovaném roce. Následují posléze ještě dva další náhledy, které zobrazují průměry cen potravin a jejich vývoj.

#OTÁZKA 5 - Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce,  projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
Z výsledné tabulky je patrné, že růst HDP nemá vždy přímo vliv na růst cen potravin či platů v ČR. Například v roce 2015 se zvýšilo HDP o 5,39% a ceny potravin ve stejném roce i roce následujícím, klesaly.
Nelze tedy s jistotou potvrdit ani vyvrátit, že existuje přímá závislost HDP na ceny potravin a platů.
Opět byl vytvořený pomocný náhled, zobrazující vývoj HDP v každém sledovaném roce. Z tohohle náhledu byly zjištěny data o vývoji cen všech kategoriích potravin, všech platů a HDP pro každý sledovaný rok.
