-- 5 janvier 2017:
-- heatmap sur montreuil, pour tests:
--
-- points in 3D with m2_price as z:
select st_asewkt(geom)
from observations_for_carto;

select min(m2_price), max(m2_price)
from observations_for_carto
where code_insee = '93048';

with tmp as (
  select min(st_z(geom)), max(st_z(geom))
  from observations_for_carto
  where code_insee = '93048'
) select array_to_json(
           array_agg(
               array[
               st_y(st_transform(geom, 4326)),
               st_x(st_transform(geom, 4326)),
               (st_z(geom) - t.min)/(t.max -t.min)
               ]
           )
       ) as price_json
from observations_for_carto b, tmp t
where code_insee = '93048';

-- same query without normalisation
select array_to_json(
             array_agg(
                 array[
                 st_y(st_transform(geom, 4326)),
                 st_x(st_transform(geom, 4326)),
                 st_z(geom)
                 ]
             )
         ) as price_json
  from observations_for_carto b
  where code_insee = '93048';

-- for heatmap js
select array_to_json(
             row_to_json((select l from (select
                 st_y(st_transform(geom, 4326)) as lat,
                 st_x(st_transform(geom, 4326)) as lng,
                 st_z(geom) as value) as l)) as price_json
  from observations_for_carto b
  where code_insee = '93048';


SELECT array_to_json(array_agg((select t from (
  select row_to_json((SELECT l FROM (SELECT st_y(st_transform(geom, 4326)) as lat,
                                       st_x(st_transform(geom, 4326)) as lng,
                                       st_z(geom) as value) AS l)) AS data) as t)))
  FROM observations_for_carto b
where code_insee = '93048';

-- demo alsace avec zones json et raster:
select id, name, node_path, geomsimple_4326
from administrative_boundaries a
where a.node_path = '0';

select id, name, node_path, st_asgeojson(a.geomsimple_4326, 5) as geojson
from administrative_boundaries a
where a.node_path = '0';

-- child zone query:
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
              where a.node_path ~ '0.*{1}'
            ) AS f
     ) AS fc;

select node_path, admin_level, name
from administrative_boundaries
where node_path ~ '0.*{1}';


-- query to get neighbours
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
              FROM administrative_boundaries a, (select admin_level, geomsimple_4326 from administrative_boundaries where node_path = '0.44.54.54508') as t
              where a.node_path <> '0.44.54.54508' and a.admin_level = t.admin_level and st_intersects(a.geomsimple_4326, t.geomsimple_4326)
            ) AS f
     ) AS fc;


-- prepare big raster with several resolutions.
-- test data on baro3_osmbarodata
with tmp as (
    SELECT st_setSRID(st_makePoint(st_X(st_centroid(b.geometry)), st_Y(st_centroid(b.geometry)), median_price_m2),
                      3857) AS geom
    FROM baro3_osmbarodata b
    WHERE b.admin_level = 8
) SELECT min(st_Z(geom)), max(st_Z(geom)) from tmp;


-- mask france simplified
DROP TABLE IF EXISTS tmpmask;
create table tmpmask as (
  WITH tmp AS (
      SELECT st_dump(geom) AS d
      FROM administrative_boundaries
      WHERE admin_level = 2
  ) SELECT st_simplifypreservetopology((d).geom, 1000) as geom
    FROM tmp
    ORDER BY st_area((d).geom) DESC
    LIMIT 1
);


-- new obs
select distinct substring(code_insee, 1, 2) from observations_for_carto
where not is_outlier;

with tmp as (
    SELECT st_setSRID(st_makePoint(st_X(st_centroid(b.point)), st_Y(st_centroid(b.point)), m2_price),
                      3857) AS geom
    FROM observations_for_carto b
    WHERE b.code_insee = '44' and not is_outlier
) SELECT min(st_Z(geom)), max(st_Z(geom)) from tmp;

SELECT st_setSRID(st_makePoint(st_X(st_centroid(b.point)), st_Y(st_centroid(b.point)), m2_price),3857) AS geom FROM observations_for_carto b WHERE b.code_insee = '44' not is_outlier;

select id, geom from administrative_boundaries where code_insee='44' and admin_level = 4;