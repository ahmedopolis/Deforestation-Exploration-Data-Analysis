/* ------------- STEPS TO COMPLETE ------------- */

/* Create 'forestation' table using 'forest_area', 'land_area', 'regions'. */
CREATE VIEW forestation AS SELECT fa.country_name AS country,
    fa.country_code AS code,
    fa.year AS year,
    CAST((fa.forest_area_sqkm) AS NUMERIC) AS forest_area_sqkm,
    CAST
    re.region,
    re.income_group,
 FROM forest_area fa
JOIN land_area la
    ON fa.country_code = la.country_code
        AND fa.year = fa.year

/* Check if 'forestation' table exist */
DROP VIEW IF EXISTS forestation;