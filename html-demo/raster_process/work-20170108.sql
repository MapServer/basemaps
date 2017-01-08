-- 08 janvier 2017:
-- suite de la demo:
-- rue niveau commune: clic sur rues => prix, click a cote: zone:
--
CREATE INDEX baro3_streetprice_insee_code_idx
  ON baro3_streetprice (insee_code);
VACUUM ANALYSE baro3_streetprice;

SELECT
  s.id,
  s.name,
  s.median_price_m2
FROM baro3_streetprice s
WHERE s.insee_code = '67511';

-- json query, bordel !!
WITH tmp AS (
    SELECT
      'Feature'                                  AS type,
      ST_AsGeoJSON(s.geomsimple_4326, 5) :: JSON AS geometry,
      row_to_json((SELECT l
                   FROM (SELECT
                           s.id,
                           s.name) AS l))        AS properties
    FROM baro3_streetprice s
    WHERE s.insee_code = '67511'
), tmp1 AS (
    SELECT
      'FeatureCollection'         AS type,
      array_to_json(array_agg(t)) AS features
    FROM tmp t
) SELECT row_to_json(t) AS json
  FROM tmp1 t;


SELECT
  s.id,
  s.name,
  s.median_price_m2,
  s.insee_code
FROM baro3_streetprice s
WHERE s.median_price_m2 > 0
      AND insee_code LIKE '54%';

-- test grid on full commune extent:
-- gdal_grid -a_srs EPSG:3857 --config GDAL_NUM_THREADS ALL_CPUS -a invdist:power=2:smoothin=50 \
-- -outsize 512 512 -txe 823428 830046 -tye 6123415 6130680 \
-- -sql "SELECT  o.node_path,  o.point,  o.m2_price FROM observations_for_carto o where not o.is_outlier and node_path ~ '0.44.68.68143.*'" \
-- PG:"dbname=osm host=localhost port=5438 user=nicolas password=aimelerafting" \
-- /Volumes/GROSSD/tmp/effiprice/grid_$node_path.tif > /tmp/gdal_grid.out

-- ok works well:
-- prepare zone extent in query:
--
SELECT
  a.node_path,
  nlevel(a.node_path) AS nlevel,
  a.ramp,
  st_xmin(ab.geom::box2d)::int as xmin, st_xmax(ab.geom::box2d)::int as xmax,
    st_ymin(ab.geom::box2d)::int as ymin , st_ymax(ab.geom::box2d) as ymax,
  st_asgeojson(ab.geom) as json
FROM admin_bound_values a join administrative_boundaries ab on a.node_path = ab.node_path
WHERE valid AND a.node_path = '0.44.68.68143'
ORDER BY nlevel(a.node_path), a.node_path DESC;

-- test MS heatmap:
-- points query according to nodepath:
select point as geom, node_path::text, m2_price from observations_for_carto where not is_outlier and node_path <@ '0.44.55.55502';

select * from colorramp;

SELECT  o.node_path,  o.point,  o.m2_price FROM observations_for_carto o where not o.is_outlier and node_path ~ '0.44.*';

select min(m2_price)/255, max(m2_price)/255
FROM observations_for_carto
where code_insee = '44' and not is_outlier;

-- test classif on 255 values :))
alter table observations_for_carto add column mspixel SMALLINT;

WITH tmp AS (
    SELECT id,
      m2_price,
      subpath(o.node_path, 0, nlevel(o.node_path) - 2) as node_path,
      ntile(256)
      OVER (PARTITION BY subpath(o.node_path, 0, nlevel(o.node_path) - 2)
        ORDER BY m2_price)                             AS ntile
    FROM observations_for_carto o
) update observations_for_carto o set mspixel = t.ntile -1
from tmp t
where o.id = t.id;

VACUUM ANALYSE observations_for_carto;