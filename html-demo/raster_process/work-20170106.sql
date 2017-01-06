-- 06 janvier 2017:
-- tests MS live vs pregenerated avec gdal, format JPG.
--
-- 1°) couleurs MS:
-- ('1'        , '0 104 55'),
-- ('2'        , '26 152 80'),
-- ('3'        , '102 189 99'),
-- ('4'        , '166 217 106'),
-- ('5'        , '217 239 139'),
-- ('6'        , '255 255 191'),
-- ('7'        , '254 224 139'),
-- ('8'        , '253 174 97'),
-- ('9'        , '244 109 67'),
-- ('10'        , '215 48 39'),
-- ('11'        , '165 0 38');


-- stats price: classif ntile:
WITH tmp AS (
    SELECT
      m2_price,
      ntile(11)
      OVER (
        ORDER BY m2_price),
      row_number()
      OVER () AS id
    FROM observations_for_carto o
    WHERE o.code_insee = '44' AND NOT o.is_outlier
), tmp1 AS (
    SELECT
      ntile,
      min(t.m2_price),
      max(t.m2_price),
      count(*),
      CASE
      WHEN ntile = 1
        THEN 'val' || ntile || '=' || max(t.m2_price) :: INT :: TEXT
      WHEN ntile = 11
        THEN 'val' || ntile || '=' || min(t.m2_price) :: INT :: TEXT
      ELSE 'val' || (ntile - 1) || '=' || min(t.m2_price) :: INT :: TEXT || ' val' || ntile || '=' ||
           max(t.m2_price) :: INT :: TEXT END                            AS intervals,
      CASE
      WHEN ntile = 1
        THEN 'val' || ntile || '=' || max(t.m2_price) :: INT :: TEXT
      WHEN ntile = 11
        THEN 'val' || ntile || '=' || min(t.m2_price) :: INT :: TEXT
      ELSE 'val' || (ntile) || '=' || max(t.m2_price) :: INT :: TEXT END AS vals

    FROM tmp t
    GROUP BY ntile
    ORDER BY ntile
) SELECT string_agg(vals, '&')
  FROM tmp1;

-- URL mapfile:
--
-- TODO: exclure extremes ou classes et reclassifier
-- test ms
-- ok

-- dem HD + overviews + compression
--  sets prices in 3D:
ALTER TABLE observations_for_carto
  ALTER COLUMN point TYPE GEOMETRY(POINTZ, 3857)
  USING st_setSRID(st_makePoint(st_X(point), st_Y(point), m2_price :: INT), 3857);

VACUUM ANALYSE observations_for_carto;

-- ex cmd grid precise:
gdal_grid - OF GTiff -a_srs EPSG:3857 \
--config JPEG_QUALITY_OVERVIEW 20 \
-co COMPRESS=LZW \
-outsize 2048 2048 \
--config GDAL_NUM_THREADS ALL_CPUS -a "invdist:power=2:smoothing:50" \
- SQL "SELECT point AS geom FROM observations_for_carto b WHERE b.code_insee = '44' and not is_outlier" \
PG:"dbname=osm host=localhost port=5438 user=nicolas password=aimelerafting" \
../ DATA /price_dem.tif

gdaladdo -r average ../ DATA /price_dem.tif 2 4 8 16

-- big file:
gdal_grid - OF GTiff -a_srs EPSG:3857 \
--config JPEG_QUALITY_OVERVIEW 20 \
-co COMPRESS=LZW \
-outsize 10240 10240 \
--config GDAL_NUM_THREADS ALL_CPUS -a "invdist:power=2:smoothing:50" \
- SQL "SELECT point AS geom FROM observations_for_carto b WHERE b.code_insee = '44' and not is_outlier" \
PG:"dbname=osm host=localhost port=5438 user=nicolas password=aimelerafting" \
/Volumes/GROSSD/tmp/price_dem.tif

gdaladdo -r average /Volumes/GROSSD/tmp/price_dem.tif 2 4 8 16 32 64

-- nouvelle classif

-- test colorrange on the raster
-- pas beau= ask thomas:

-- nouvelle table admin_bound_values valeurs des classes pour les admin bounds:
-- valeurs a appliquer au DEM pour classifier les prix
-- id, node_path, values (text)
--
-- france: admin_level 2:
-- group by node_path a faire pour les différentes aggreg
CREATE INDEX observations_for_carto_point_gist
  ON observations_for_carto USING GIST (point);
VACUUM ANALYSE observations_for_carto;

DROP TABLE admin_bound_values;
CREATE TABLE admin_bound_values AS (
  WITH tmp AS (
      SELECT
        m2_price,
        a.code_insee,
        subpath(a.node_path, 0, nlevel(a.node_path) - 2) AS node_path,
        ntile(11)
        OVER (PARTITION BY subpath(a.node_path, 0, nlevel(a.node_path) - 2)
          ORDER BY m2_price)                             AS ntile,
        row_number()
        OVER ()                                          AS id
      FROM observations_for_carto o
        JOIN administrative_boundaries a ON st_contains(a.geom, o.point)
      WHERE o.code_insee = '44' AND NOT o.is_outlier
            AND a.admin_level IN (8, 9)
  ), tmp1 AS (
      SELECT
        ntile,
        node_path,
        min(t.m2_price),
        max(t.m2_price),
        count(*),
        CASE
        WHEN ntile = 1
          THEN 'val' || ntile || '=' || max(t.m2_price) :: INT :: TEXT
        WHEN ntile = 11
          THEN 'val' || ntile || '=' || min(t.m2_price) :: INT :: TEXT
        ELSE 'val' || (ntile - 1) || '=' || min(t.m2_price) :: INT :: TEXT || ' val' || ntile || '=' ||
             max(t.m2_price) :: INT :: TEXT END                            AS intervals,
        CASE
        WHEN ntile = 1
          THEN 'val' || ntile || '=' || max(t.m2_price) :: INT :: TEXT
        WHEN ntile = 11
          THEN 'val' || ntile || '=' || min(t.m2_price) :: INT :: TEXT
        ELSE 'val' || (ntile) || '=' || max(t.m2_price) :: INT :: TEXT END AS vals

      FROM tmp t
      GROUP BY ntile, node_path
      ORDER BY ntile
  ) SELECT
      node_path,
      string_agg(vals, '&') AS values
    FROM tmp1
    GROUP BY node_path
);

-- dept
WITH tmp AS (
    SELECT
      m2_price,
      a.code_insee,
      subpath(a.node_path, 0, nlevel(a.node_path) - 1) AS node_path,
      ntile(11)
      OVER (PARTITION BY subpath(a.node_path, 0, nlevel(a.node_path) - 1)
        ORDER BY m2_price)                             AS ntile,
      row_number()
      OVER ()                                          AS id
    FROM observations_for_carto o
      JOIN administrative_boundaries a ON st_contains(a.geom, o.point)
    WHERE o.code_insee = '44' AND NOT o.is_outlier
          AND a.admin_level IN (8, 9)
), tmp1 AS (
    SELECT
      ntile,
      node_path,
      min(t.m2_price),
      max(t.m2_price),
      count(*),
      CASE
      WHEN ntile = 1
        THEN 'val' || ntile || '=' || max(t.m2_price) :: INT :: TEXT
      WHEN ntile = 11
        THEN 'val' || ntile || '=' || min(t.m2_price) :: INT :: TEXT
      ELSE 'val' || (ntile - 1) || '=' || min(t.m2_price) :: INT :: TEXT || ' val' || ntile || '=' ||
           max(t.m2_price) :: INT :: TEXT END                            AS intervals,
      CASE
      WHEN ntile = 1
        THEN 'val' || ntile || '=' || max(t.m2_price) :: INT :: TEXT
      WHEN ntile = 11
        THEN 'val' || ntile || '=' || min(t.m2_price) :: INT :: TEXT
      ELSE 'val' || (ntile) || '=' || max(t.m2_price) :: INT :: TEXT END AS vals

    FROM tmp t
    GROUP BY ntile, node_path
    ORDER BY ntile
) INSERT INTO admin_bound_values (node_path, values)
  SELECT
    node_path,
    string_agg(vals, '&') AS values
  FROM tmp1
  GROUP BY node_path;

-- commune
WITH tmp AS (
    SELECT
      m2_price,
      a.code_insee,
      subpath(a.node_path, 0, nlevel(a.node_path)) AS node_path,
      ntile(11)
      OVER (PARTITION BY subpath(a.node_path, 0, nlevel(a.node_path))
        ORDER BY m2_price)                         AS ntile,
      row_number()
      OVER ()                                      AS id
    FROM observations_for_carto o
      JOIN administrative_boundaries a ON st_contains(a.geom, o.point)
    WHERE o.code_insee = '44' AND NOT o.is_outlier
          AND a.admin_level IN (8, 9)
), tmp1 AS (
    SELECT
      ntile,
      node_path,
      min(t.m2_price),
      max(t.m2_price),
      count(*),
      CASE
      WHEN ntile = 1
        THEN 'val' || ntile || '=' || max(t.m2_price) :: INT :: TEXT
      WHEN ntile = 11
        THEN 'val' || ntile || '=' || min(t.m2_price) :: INT :: TEXT
      ELSE 'val' || (ntile - 1) || '=' || min(t.m2_price) :: INT :: TEXT || ' val' || ntile || '=' ||
           max(t.m2_price) :: INT :: TEXT END                            AS intervals,
      CASE
      WHEN ntile = 1
        THEN 'val' || ntile || '=' || max(t.m2_price) :: INT :: TEXT
      WHEN ntile = 11
        THEN 'val' || ntile || '=' || min(t.m2_price) :: INT :: TEXT
      ELSE 'val' || (ntile) || '=' || max(t.m2_price) :: INT :: TEXT END AS vals

    FROM tmp t
    GROUP BY ntile, node_path
    ORDER BY ntile
) INSERT INTO admin_bound_values (node_path, values)
  SELECT
    node_path,
    string_agg(vals, '&') AS values
  FROM tmp1
  GROUP BY node_path;

-- TODO: commues avec peu de points => pas assez de valeurs.
SELECT *
FROM admin_bound_values
WHERE length(values ->> 'values') < 50;

ALTER TABLE administrative_boundaries
  ADD COLUMN values TEXT;
ALTER TABLE administrative_boundaries
  DROP COLUMN values;
UPDATE administrative_boundaries a
SET values = t.values
FROM admin_bound_values t
WHERE a.node_path = t.node_path;

-- inserts dummy for france
UPDATE administrative_boundaries a
SET
  values = 'val1=756&val2=978&val3=1158&val4=1324&val5=1484&val6=1643&val7=1807&val8=1992&val9=2228&val10=2584&val11=2584'
WHERE a.node_path = '0';

CREATE INDEX admin_bound_values_node_path_idx
  ON admin_bound_values USING GIST (node_path);

VACUUM ANALYSE admin_bound_values;
VACUUM ANALYSE administrative_boundaries;

SELECT
  st_asgeojson(a.geomsimple_4326, 5) AS geojson,
  values
FROM administrative_boundaries a
WHERE a.node_path = '0.44';


WITH tmp AS (
    SELECT
      'Feature'                                  AS type,
      ST_AsGeoJSON(a.geomsimple_4326, 5) :: JSON AS geometry,
      row_to_json((SELECT l
                   FROM (SELECT
                           node_path,
                           values) AS l))        AS properties
    FROM administrative_boundaries a
    WHERE a.node_path ~ '0'
) SELECT row_to_json(t)
  FROM tmp t;

WITH tmp AS (
    SELECT
      'FeatureCollection'         AS type,
      array_to_json(array_agg(f)) AS features
    FROM (
           SELECT
             'Feature'                                  AS type,
             ST_AsGeoJSON(a.geomsimple_4326, 5) :: JSON AS geometry,
             row_to_json((SELECT l
                          FROM (SELECT
                                  a.id,
                                  a.name,
                                  a.admin_level,
                                  node_path) AS l))     AS properties
           FROM administrative_boundaries a
           WHERE a.node_path ~ '" . $nodePath . ".*{1}'
         ) AS f
)

SELECT row_to_json(fc)
FROM (
       SELECT
         'FeatureCollection'         AS type,
         array_to_json(array_agg(f)) AS features
       FROM (
              SELECT
                'Feature'                                  AS type,
                ST_AsGeoJSON(a.geomsimple_4326, 5) :: JSON AS geometry,
                row_to_json((SELECT l
                             FROM (SELECT
                                     a.id,
                                     a.name,
                                     a.admin_level,
                                     node_path) AS l))     AS properties
              FROM administrative_boundaries a
              WHERE a.node_path ~ '" . $nodePath . ".*{1}'
            ) AS f
     ) AS fc;

-------------------------------------------------------------------------------------
-- deuxieme approche:
-- prégénération des images:
-------------------------------------------------------------------------------------
-- TODO: observations avec code_insee ou node_path
-- requete des observations par zones, pour les différentes grilles:
SELECT node_path
FROM admin_bound_values
WHERE node_path = '0.44'
ORDER BY nlevel(node_path);

-- adds node_path column to obs:
ALTER TABLE observations_for_carto
  ADD COLUMN node_path ltree;
ALTER TABLE observations_for_carto
  ADD COLUMN id SERIAL PRIMARY KEY;

UPDATE observations_for_carto o
SET node_path = ab.node_path
FROM administrative_boundaries ab
WHERE st_contains(ab.geom, o.point)
      AND ab.admin_level IN (8, 9);

CREATE INDEX observations_for_carto_node_path_gist
  ON observations_for_carto USING GIST (node_path);
VACUUM ANALYSE observations_for_carto;

SELECT
  o.node_path,
  o.point,
  o.m2_price
FROM observations_for_carto o
WHERE node_path ~ '0.44.*';

SELECT st_isvalid(st_simplifyPreserveTopology(geom, 0.010))
FROM administrative_boundaries
WHERE node_path = '0.44.08.08004';

SELECT
  node_path,
  nlevel(node_path) AS nlevel
FROM admin_bound_values
ORDER BY nlevel(node_path);

-- classif pour la generation live:
-- générer une rampe de couleurs:
-- utilisation de la colonne observations_for_carto.node_path
-- colors:
DROP TABLE IF EXISTS colorramp;
CREATE TABLE colorramp AS (
  SELECT
    1 :: INT    AS id,
    '18 130 34' AS clr
  UNION ALL
  SELECT
    2 :: INT   AS id,
    '68 217 7' AS clr
  UNION ALL
  SELECT
    3 :: INT     AS id,
    '230 255 12' AS clr
  UNION ALL
  SELECT
    4 :: INT    AS id,
    '252 117 9' AS clr
  UNION ALL
  SELECT
    5 :: INT  AS id,
    '255 0 7' AS clr
);

ALTER TABLE admin_bound_values
  ADD COLUMN ramp TEXT;

-- region
WITH tmp AS (
    SELECT
      id,
      m2_price,
      subpath(node_path, 0, nlevel(node_path) - 2) AS node_path,
      ntile(7)
      OVER (PARTITION BY subpath(node_path, 0, nlevel(node_path) - 2)
        ORDER BY m2_price)                         AS ntile
    FROM observations_for_carto o
    WHERE code_insee = '44' AND NOT o.is_outlier
), tmp1 AS (
    SELECT
      ntile,
      node_path,
      min(t.m2_price),
      max(t.m2_price),
      count(*),
      c.clr
    FROM tmp t
      JOIN colorramp c ON t.ntile = c.id + 1
    WHERE ntile NOT IN (1, 7)
    GROUP BY ntile, node_path, c.clr
    ORDER BY ntile
), tmp2 AS (
    SELECT
      node_path,
      string_agg(max :: INT :: TEXT || ' ' || clr, ',') AS ramp
    FROM tmp1
    GROUP BY node_path
) UPDATE admin_bound_values o
SET ramp = t.ramp
FROM tmp2 t
WHERE o.node_path = t.node_path;

-- dept
WITH tmp AS (
    SELECT
      id,
      m2_price,
      subpath(node_path, 0, nlevel(node_path) - 1) AS node_path,
      ntile(7)
      OVER (PARTITION BY subpath(node_path, 0, nlevel(node_path) - 1)
        ORDER BY m2_price)                         AS ntile
    FROM observations_for_carto o
    WHERE code_insee = '44' AND NOT o.is_outlier
), tmp1 AS (
    SELECT
      ntile,
      node_path,
      min(t.m2_price),
      max(t.m2_price),
      count(*),
      c.clr
    FROM tmp t
      JOIN colorramp c ON t.ntile = c.id + 1
    WHERE ntile NOT IN (1, 7)
    GROUP BY ntile, node_path, c.clr
    ORDER BY ntile
), tmp2 AS (
    SELECT
      node_path,
      string_agg(max :: INT :: TEXT || ' ' || clr, ',') AS ramp
    FROM tmp1
    GROUP BY node_path
) UPDATE admin_bound_values o
SET ramp = t.ramp
FROM tmp2 t
WHERE o.node_path = t.node_path;

-- commune
WITH tmp AS (
    SELECT
      id,
      m2_price,
      subpath(node_path, 0, nlevel(node_path)) AS node_path,
      ntile(7)
      OVER (PARTITION BY subpath(node_path, 0, nlevel(node_path))
        ORDER BY m2_price)                     AS ntile
    FROM observations_for_carto o
    WHERE code_insee = '44' AND NOT o.is_outlier
), tmp1 AS (
    SELECT
      ntile,
      node_path,
      min(t.m2_price),
      max(t.m2_price),
      count(*),
      c.clr
    FROM tmp t
      JOIN colorramp c ON t.ntile = c.id + 1
    WHERE ntile NOT IN (1, 7)
    GROUP BY ntile, node_path, c.clr
    ORDER BY ntile
), tmp2 AS (
    SELECT
      node_path,
      string_agg(max :: INT :: TEXT || ' ' || clr, ',') AS ramp
    FROM tmp1
    GROUP BY node_path
) UPDATE admin_bound_values o
SET ramp = t.ramp
FROM tmp2 t
WHERE o.node_path = t.node_path;

-- TODO: communes sans ramp:
UPDATE admin_bound_values
SET ramp = ''
WHERE ramp IS NULL;
-- 404 rows...

-- ok, nice dynamic ramps for each admin level ;)

-- couche Mapserver test2: variable to get the right image according to node_path:
-- ok

-- data problems:
-- TODO: no point in commune
-- TODO: not enough classes
SELECT a.*
FROM admin_bound_values a
WHERE a.ramp = ''
      OR (array_length(string_to_array(ramp, ','), 1) - 1 < 4);

-- 1460/4400 !!
WITH tmp AS (
    SELECT
      id,
      m2_price,
      subpath(node_path, 0, nlevel(node_path)) AS node_path,
      ntile(7)
      OVER (PARTITION BY subpath(node_path, 0, nlevel(node_path))
        ORDER BY m2_price)                     AS ntile,
      count(*)
      OVER (PARTITION BY subpath(node_path, 0, nlevel(node_path))
        ORDER BY m2_price)                     AS count
    FROM observations_for_carto o
    WHERE node_path = '0.44.54.54251' AND NOT o.is_outlier
) SELECT
    ntile,
    node_path,
    min(t.m2_price),
    max(t.m2_price),
    count,
    c.clr
  FROM tmp t
    JOIN colorramp c ON t.ntile = c.id + 1
  WHERE ntile NOT IN (1, 7)
  GROUP BY ntile, node_path, c.clr, count
  ORDER BY ntile;

SELECT DISTINCT ON (point) *
FROM observations_for_carto
WHERE node_path = '0.44.52.52095'
      AND NOT is_outlier;

-- all obs with few points
SELECT
  node_path,
  count(*)
FROM observations_for_carto
WHERE code_insee = '44' AND NOT is_outlier
GROUP BY node_path
HAVING count(*) < 7;
-- 1593

-- AJout colonne valid a admin_bound: plus de 7 points distincs => stat faisable
ALTER TABLE admin_bound_values
  ADD COLUMN valid BOOLEAN DEFAULT TRUE;

WITH tmp AS (
    SELECT DISTINCT ON (point) *
    FROM observations_for_carto
    WHERE NOT is_outlier
), tmp1 AS (
    SELECT
      node_path,
      count(*)
    FROM tmp
    WHERE code_insee = '44' AND NOT is_outlier
    GROUP BY node_path
    HAVING count(*) < 7
) UPDATE admin_bound_values a
SET valid = FALSE
FROM tmp1 t
WHERE a.node_path = t.node_path;

CREATE INDEX admin_bound_values_valid_idx
  ON admin_bound_values (valid);

VACUUM ANALYSE admin_bound_values;

-- display invalid comm in mapfile:
SELECT
  id,
  st_transform(geomsimple_4326, 3857) AS geom
FROM administrative_boundaries a
  JOIN admin_bound_values aa ON a.node_path = aa.node_path
WHERE a.admin_level IN (8, 9) AND NOT aa.valid;

-- TODO: force commune extent for grid to ensure mask is covered

SELECT count(*)
FROM admin_bound_values
WHERE valid;


SELECT
  node_path,
  nlevel(node_path) AS nlevel,
  ramp
FROM admin_bound_values
WHERE not valid

ORDER BY nlevel(node_path), node_path DESC;

-- TODO: test metz en smoothing et power
-- si ok, custom smoothing/power.