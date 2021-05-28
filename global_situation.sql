/* ------------- Part 1 - Global Situation ------------- */

/* What was the total forest area (in sq km) of the world in 1990? */
SELECT DISTINCT year, 
    forest_area_sqkm 
FROM forestation
WHERE code = 'WLD'
AND year = '1990';
-- year	  forest_area_sqkm
-- 1990	  41282694.9

/* What was the total forest area (in sq km) of the world in 2016? */
SELECT DISTINCT year, 
    forest_area_sqkm 
FROM forestation
WHERE code = 'WLD'
AND year = '2016';
-- year	  forest_area_sqkm
-- 2016	  39958245.9

/* What was the change (in sq km) in the forest area of the world from 1990 to 2016? */
SELECT year,
    forest_area_sqkm, 
    forest_area_sqkm - LEAD(forest_area_sqkm) OVER (ORDER BY year) AS world_forest_area_change_sqkm
FROM    (SELECT DISTINCT code, year, 
        forest_area_sqkm 
    FROM forestation 
    WHERE (year = '1990' OR year = '2016')
    AND code = 'WLD'
) AS world_forest_area_for_1990_2016_sqkm;
-- year	  forest_area_sqkm	  world_forest_area_change_sqkm
-- 1990	  41282694.9	      1324449.0
-- 2016	  39958245.9	

/* What was the percent change in forest area of the world between 1990 and 2016? */
SELECT year,
    forest_area_sqkm, 
    ROUND((100*(forest_area_sqkm - LEAD(forest_area_sqkm) OVER (ORDER BY year))/forest_area_sqkm),2) AS world_percentage_forest_area_change
FROM    (SELECT DISTINCT code, year, 
        forest_area_sqkm 
    FROM forestation 
    WHERE (year = '1990' OR year = '2016')
    AND code = 'WLD'
) AS world_forest_area_for_1990_2016_sqkm;
-- year	  forest_area_sqkm	  world_percentage_forest_area_change
-- 1990	  41282694.9	      3.21
-- 2016	  39958245.9

/* If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to? */
WITH T1 AS (SELECT DISTINCT ft1.forest_area_sqkm - ft2.forest_area_sqkm AS world_forest_area_change_sqkm
    FROM forestation ft1,
        forestation ft2
    WHERE (ft1.code = 'WLD' AND ft1.year = '1990')
    AND (ft2.code = 'WLD' AND ft2.year = '2016'))
SELECT DISTINCT ft.country,
    ft.total_area_sqkm,
    ABS(total_area_sqkm - T1.world_forest_area_change_sqkm) AS forest_change_vs_country_size_difference
FROM forestation ft, T1
ORDER BY forest_change_vs_country_size_difference
LIMIT 1
-- country	total_area_sqkm	forest_change_vs_country_size_difference
-- Peru	    1279999.9891	44449.0109