/* ------------- Part 3 - Country-Level Detail ------------- */

/* Create table for country-level forest area change and percentage comparing 1990 and 2016. */
CREATE VIEW country_level_ft AS SELECT DISTINCT ft1.country,
    ft1.region,
    ft1.forest_area_sqkm AS forest_area_sqkm_2016,
    ft2.forest_area_sqkm AS forest_area_sqkm_1990,
    ft1.forest_area_sqkm - ft2.forest_area_sqkm AS difference_forest_area_1990_vs_2016_sqkm,
    ROUND(100*((ft1.forest_area_sqkm - ft2.forest_area_sqkm)/ft2.forest_area_sqkm),2) AS percentage_area_1990_vs_2016
FROM forestation ft1,
    forestation ft2
WHERE (ft1.year = '2016' AND ft2.year = '1990')
AND (ft1.country = ft2.country);


/* Check if 'forestation' table exist */
DROP VIEW IF EXISTS country_level_ft;

/* What are the two countries with the highest increase in forest area? */
SELECT country,
    difference_forest_area_1990_vs_2016_sqkm
FROM country_level_ft
WHERE difference_forest_area_1990_vs_2016_sqkm IS NOT NULL
AND country != 'World'
ORDER BY difference_forest_area_1990_vs_2016_sqkm DESC
LIMIT 2;
-- country	        difference_forest_area_1990_vs_2016_sqkm
-- China	        527229.062
-- United States	79200

/* What is the country with the highest percentage increase in forest area? */
SELECT country,
    percentage_area_1990_vs_2016
FROM country_level_ft
WHERE percentage_area_1990_vs_2016 IS NOT NULL
AND country != 'World'
ORDER BY percentage_area_1990_vs_2016 DESC
LIMIT 1;
-- country	percentage_area_1990_vs_2016
-- Iceland	213.66

/* Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each? */
SELECT country,
    region,
    difference_forest_area_1990_vs_2016_sqkm
FROM country_level_ft
WHERE difference_forest_area_1990_vs_2016_sqkm IS NOT NULL
AND country != 'World'
ORDER BY difference_forest_area_1990_vs_2016_sqkm 
LIMIT 5;
-- country	  region	                 difference_forest_area_1990_vs_2016_sqkm
-- Brazil	  Latin America & Caribbean	 -541510
-- Indonesia  East Asia & Pacific	     -282193.9844
-- Myanmar	  East Asia & Pacific	     -107234.0039
-- Nigeria	  Sub-Saharan Africa	     -106506.00098
-- Tanzania	  Sub-Saharan Africa	     -102320

/* Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each? */
SELECT country,
    region,
    percentage_area_1990_vs_2016
FROM country_level_ft
WHERE percentage_area_1990_vs_2016 IS NOT NULL
AND country != 'World'
ORDER BY percentage_area_1990_vs_2016 
LIMIT 5;
-- country	    region	                    percentage_area_1990_vs_2016
-- Togo	        Sub-Saharan Africa	        -75.45
-- Nigeria	    Sub-Saharan Africa	        -61.80
-- Uganda	    Sub-Saharan Africa	        -59.13
-- Mauritania	Sub-Saharan Africa	        -46.75
-- Honduras	    Latin America & Caribbean	-45.03

/* If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016? */
WITH T1 AS (SELECT country, 
    year, 
    ROUND(AVG(percentage_forestation), 2) AS average_percentage_forestation
FROM forestation
WHERE (year = '2016' AND percentage_forestation IS NOT NULL)
GROUP BY 1, 2
),
T2 AS (SELECT country,
    average_percentage_forestation,
    CASE WHEN average_percentage_forestation <= 25
    THEN 'FIRST_QUARTILE'
    WHEN average_percentage_forestation <= 50
    THEN 'SECOND_QUARTILE'
    WHEN average_percentage_forestation <= 75
    THEN 'THIRD_QUARTILE'
    WHEN average_percentage_forestation <= 100
    THEN 'FOURTH_QUARTILE'
    END AS percentile_forestation
FROM T1)
SELECT percentile_forestation,
    COUNT(*) AS countries_per_percentile
FROM T2
GROUP BY 1
ORDER BY countries_per_percentile DESC;
-- percentile_forestation	countries_per_percentile
-- FIRST_QUARTILE	        85
-- SECOND_QUARTILE	        74
-- THIRD_QUARTILE	        37
-- FOURTH_QUARTILE	        9

/* List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.*/
WITH T1 AS (SELECT country, 
    year,
    region, 
    ROUND(AVG(percentage_forestation), 2) AS average_percentage_forestation
FROM forestation
WHERE (year = '2016' AND percentage_forestation IS NOT NULL)
GROUP BY 1, 2, 3
),
T2 AS (SELECT country,
    region,
    average_percentage_forestation,
    CASE WHEN average_percentage_forestation <= 25
    THEN 'FIRST_QUARTILE'
    WHEN average_percentage_forestation <= 50
    THEN 'SECOND_QUARTILE'
    WHEN average_percentage_forestation <= 75
    THEN 'THIRD_QUARTILE'
    WHEN average_percentage_forestation <= 100
    THEN 'FOURTH_QUARTILE'
    END AS percentile_forestation
FROM T1)
SELECT country,
    region,
    average_percentage_forestation
FROM T2
WHERE percentile_forestation = 'FOURTH_QUARTILE'
ORDER BY average_percentage_forestation DESC;
-- country	                region	                    average_percentage_forestation
-- Suriname	                Latin America & Caribbean	98.26
-- Micronesia, Fed. Sts.	East Asia & Pacific	        91.86
-- Gabon	                Sub-Saharan Africa	        90.04
-- Seychelles	            Sub-Saharan Africa	        88.41
-- Palau	                East Asia & Pacific	        87.61
-- American Samoa	        East Asia & Pacific	        87.50
-- Guyana	                Latin America & Caribbean	83.90
-- Lao PDR	                East Asia & Pacific	        82.11
-- Solomon Islands	        East Asia & Pacific	        77.86

/* How many countries had a percent forestation higher than the United States in 2016? */
WITH T1 AS (SELECT country, 
    year,
    ROUND(AVG(percentage_forestation), 2) AS average_percentage_forestation
FROM forestation
WHERE (year = '2016' AND percentage_forestation IS NOT NULL)
GROUP BY 1, 2
),
T2 AS (SELECT average_percentage_forestation
FROM T1
WHERE country = 'United States'),
T3 AS (SELECT T1.country,
    T1.average_percentage_forestation
FROM T1, T2
WHERE (T1.average_percentage_forestation > T2.average_percentage_forestation))
SELECT COUNT(*) AS count_countries 
FROM T3;
-- count_countries
-- 95 