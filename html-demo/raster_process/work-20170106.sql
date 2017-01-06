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
with tmp as (
    SELECT
      m2_price,
      ntile(11)
      OVER (
        ORDER BY m2_price),
      row_number() over () as id
    FROM observations_for_carto o
    WHERE o.code_insee = '44' and not o.is_outlier
), tmp1 as (
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
           max(t.m2_price) :: INT :: TEXT END                              AS intervals,
      CASE
      WHEN ntile = 1
        THEN 'val' || ntile || '=' || max(t.m2_price) :: INT :: TEXT
      WHEN ntile = 11
        THEN 'val' || ntile || '=' || min(t.m2_price) :: INT :: TEXT
      ELSE 'val' || (ntile) || '=' || max(t.m2_price) :: INT :: TEXT END AS vals

    FROM tmp t
    GROUP BY ntile
    ORDER BY ntile
) select string_agg(vals, '&')
from tmp1;

-- URL mapfile:
--
-- TODO: exclure extremes ou classes et reclassifier
-- test ms
-- ok

-- dem HD + overviews + compression
--  sets prices in 3D:
alter TABLE observations_for_carto alter column point type geometry(POINTZ, 3857)
  using st_setSRID(st_makePoint(st_X(point), st_Y(point), m2_price::int),3857);

VACUUM analyse observations_for_carto;

-- ex cmd grid precise:
gdal_grid -of GTiff -a_srs EPSG:3857 \
  --config JPEG_QUALITY_OVERVIEW 20 \
  -co COMPRESS=LZW \
  -outsize 2048 2048 \
  --config GDAL_NUM_THREADS ALL_CPUS -a "invdist:power=2:smoothing:50" \
  -sql "SELECT point AS geom FROM observations_for_carto b WHERE b.code_insee = '44' and not is_outlier" \
  PG:"dbname=osm host=localhost port=5438 user=nicolas password=aimelerafting" \
  ../data/price_dem.tif

gdaladdo -r average ../data/price_dem.tif 2 4 8 16

-- big file:
gdal_grid -of GTiff -a_srs EPSG:3857 \
  --config JPEG_QUALITY_OVERVIEW 20 \
  -co COMPRESS=LZW \
  -outsize 10240 10240 \
  --config GDAL_NUM_THREADS ALL_CPUS -a "invdist:power=2:smoothing:50" \
  -sql "SELECT point AS geom FROM observations_for_carto b WHERE b.code_insee = '44' and not is_outlier" \
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
CREATE INDEX observations_for_carto_point_gist on observations_for_carto USING gist(point);
VACUUM ANALYSE observations_for_carto;

DROP TABLE admin_bound_values;
create table admin_bound_values as (
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
) insert into admin_bound_values (node_path, values)
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
) insert into admin_bound_values (node_path, values)
  SELECT
    node_path,
    string_agg(vals, '&') AS values
  FROM tmp1
  GROUP BY node_path;

-- TODO: commues avec peu de points => pas assez de valeurs.
select *
from admin_bound_values
where length(values->>'values') < 50;

alter TABLE administrative_boundaries add column values text;
alter TABLE administrative_boundaries DROP column values ;
update administrative_boundaries a set values = t.values
from admin_bound_values t
where a.node_path = t.node_path;

-- inserts dummy for france
update administrative_boundaries a set values = 'val1=756&val2=978&val3=1158&val4=1324&val5=1484&val6=1643&val7=1807&val8=1992&val9=2228&val10=2584&val11=2584'
where a.node_path = '0';


VACUUM ANALYSE administrative_boundaries;

select st_asgeojson(a.geomsimple_4326, 5) as geojson, values
from administrative_boundaries a
where a.node_path = '0.44';


with tmp as (
    SELECT
      'Feature'                        AS type,
      ST_AsGeoJSON(a.geomsimple_4326, 5) :: JSON AS geometry,
      row_to_json((SELECT l FROM (SELECT node_path, values) AS l)) AS properties
    FROM administrative_boundaries a
    where a.node_path ~ '0'
) select row_to_json(t)
  from tmp t;

with tmp as (
    SELECT
      'FeatureCollection'         AS type,
      array_to_json(array_agg(f)) AS features
    FROM (
           SELECT
             'Feature'                        AS type,
             ST_AsGeoJSON(a.geomsimple_4326, 5) :: JSON AS geometry,
             row_to_json((SELECT l FROM (SELECT a.id, a.name, a.admin_level, node_path) AS l)) AS properties
           FROM administrative_boundaries a
           where a.node_path ~ '" . $nodePath . ".*{1}'
         ) AS f
)

SELECT row_to_json(fc)
FROM (
       SELECT
         'FeatureCollection'         AS type,
         array_to_json(array_agg(f)) AS features
       FROM (
              SELECT
                'Feature'                        AS type,
                ST_AsGeoJSON(a.geomsimple_4326, 5) :: JSON AS geometry,
                row_to_json((SELECT l FROM (SELECT a.id, a.name, a.admin_level, node_path) AS l)) AS properties
              FROM administrative_boundaries a
              where a.node_path ~ '" . $nodePath . ".*{1}'
            ) AS f
     ) AS fc;

