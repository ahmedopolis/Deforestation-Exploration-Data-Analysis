/* ------------- Part 2 - Regional Outlook ------------- */

/* Create a table that shows the regions and their percent forest areain 1990 and 2016. */
CREATE VIEW regional_outlook_ft AS SELECT year,
    region,
    ROUND(CAST(100.00*((sum_forest_area_sqkm)/(sum_total_area_sqkm)) AS NUMERIC), 2) AS percentage_forestation
FROM (SELECT DISTINCT year,
    region,
    SUM(forest_area_sqkm) AS sum_forest_area_sqkm,
    SUM(total_area_sqkm) AS sum_total_area_sqkm
FROM forestation
WHERE (year = '1990' OR year = '2016')
GROUP BY 1, 2) AS forest_total_area_per_region_for_1990_2016_sqkm;

/* Check if 'regional_outlook_ft' table exist */
DROP VIEW IF EXISTS regional_outlook_ft;

/* What was the percent forest of the entire world in 2016? */
SELECT percentage_forestation
FROM regional_outlook_ft
WHERE region = 'World'
AND year = '2016';
-- percentage_forestation
-- 31.38

/* Which region had the HIGHEST percent forest in 2016? */
SELECT region,
    percentage_forestation
FROM regional_outlook_ft
WHERE year = '2016'
AND region != 'World'
ORDER BY percentage_forestation DESC
LIMIT 1;
-- region	                percentage_forestation
-- Europe & Central Asia	46.16

/* Which region had the LOWEST percent forest in 2016? */
SELECT region,
    percentage_forestation
FROM regional_outlook_ft
WHERE year = '2016'
AND region != 'World'
ORDER BY percentage_forestation 
LIMIT 1;
-- region	                    percentage_forestation
-- Middle East & North Africa	2.07

/* What was the percent forest of the entire world in 1990? */
SELECT percentage_forestation
FROM regional_outlook_ft
WHERE region = 'World'
AND year = '1990';
-- percentage_forestation
-- 32.42

/* Which region had the HIGHEST percent forest in 1990? */
SELECT region,
    percentage_forestation
FROM regional_outlook_ft
WHERE year = '1990'
AND region != 'World'
ORDER BY percentage_forestation DESC
LIMIT 1;
-- region	                    percentage_forestation
-- Latin America & Caribbean	51.03

/* Which region had the LOWEST percent forest in 1990? */
SELECT region,
    percentage_forestation
FROM regional_outlook_ft
WHERE year = '1990'
AND region != 'World'
ORDER BY percentage_forestation 
LIMIT 1;
-- region	                    percentage_forestation
-- Middle East & North Africa	1.78

/* Which regions of the world DECREASED in forest area from 1990 to 2016? */
With T1 AS (SELECT roft1.region,
    roft2.percentage_forestation AS percentage_forestation_1990,
    roft1.percentage_forestation AS percentage_forestation_2016,
	roft1.percentage_forestation - roft2.percentage_forestation AS 	difference_percentage_forestation_1990_vs_2016
FROM regional_outlook_ft roft1,
    regional_outlook_ft roft2
WHERE (roft1.year = '2016' AND roft2.year = '1990')
AND (roft1.region = roft2.region)
ORDER BY difference_percentage_forestation_1990_vs_2016 DESC)
SELECT region,
    percentage_forestation_1990,
    percentage_forestation_2016,
    difference_percentage_forestation_1990_vs_2016,
    CASE WHEN difference_percentage_forestation_1990_vs_2016 < 0 
        THEN 'DECREASED' 
        ELSE 'INCREASED'
        END AS region_forest_trend
FROM T1
WHERE region != 'World';
-- region	                    percentage_forestation_1990	percentage_forestation_2016	difference_percentage_forestation_1990_vs_2016	region_forest_trend
-- South Asia	                16.51	                    17.51	                    1.00	                                        INCREASED
-- Europe & Central Asia	    37.28	                    38.04	                    0.76	                                        INCREASED
-- East Asia & Pacific	        25.78	                    26.36	                    0.58	                                        INCREASED
-- North America	            35.65	                    36.04	                    0.39	                                        INCREASED
-- Middle East & North Africa	1.78	                    2.07	                    0.29	                                        INCREASED
-- Sub-Saharan Africa	        30.67	                    28.79	                    -1.88	                                        DECREASED
-- Latin America & Caribbean	51.03	                    46.16	                    -4.87	                                        DECREASED


