-- 29 dec 2016:
-- maquette heatmap/raster pour les prix:
-- plus d'indicateur de prix a la rue, mais:
-- simulation de points de prix dans montreuil (93100 cp, 93048 insee) et
-- • heatmap a partir de ces points
-- • raster interpolé à partir des points: DEM-based:

-- creation jeu de test à partir des prix rues fontainebleau
-- sample des rues existantes: 5 sample par rue
-- TODO sample with street middle only
DROP TABLE IF EXISTS baro3_price;
CREATE TABLE baro3_price AS (
  WITH tmp AS (
      SELECT
        median_price_m2                                                                                    AS price,
        gs                                                                                                 AS num_sample,
        st_line_interpolate_point((st_dump(geom)).geom, gs :: FLOAT / 5 :: FLOAT) :: GEOMETRY(POINT, 3857) AS geom
      FROM baro3_streetprice
        CROSS JOIN generate_series(1, 5) AS gs
      WHERE insee_code = '93048' AND house_type = 1000
  ) SELECT t.*
    FROM tmp t
);

ALTER TABLE baro3_price
  ADD COLUMN id SERIAL PRIMARY KEY;
CREATE INDEX baro3_price_geom_gist
  ON baro3_price USING GIST (geom);

-- test 3D points for processing with 3D tools:
ALTER TABLE baro3_price
  ALTER COLUMN geom TYPE GEOMETRY(POINTZ, 3857) USING st_setSRID(st_makePoint(st_x(geom), st_y(geom), price),
                                                                 st_srid(geom));
VACUUM ANALYSE baro3_price;

-- test heatmap:

-- test DEM:
-- gdal_grid: see process.bash
-- prepare image georeferenced extent
WITH tmp AS (
    SELECT st_extent(st_transform(geom, 4326)) AS e
    FROM baro3_price
) SELECT
    st_xmin(e),
    st_xmax(e),
    st_ymin(e),
    st_ymax(e)
  FROM tmp;

-- streets json:
SELECT row_to_json(fc)
FROM (
       SELECT
         'FeatureCollection'         AS type,
         array_to_json(array_agg(f)) AS features
       FROM (
              SELECT
                'Feature'                                     AS type,
                ST_AsGeoJSON(geomsimple_4326, 5) :: JSON    AS geometry,
                row_to_json((SELECT l
                             FROM (SELECT
                                     b.id,
                                     b.median_price_m2, b.insee_code) AS l)) AS properties
              FROM baro3_streetprice b
              WHERE insee_code = '93048' AND house_type = 1000
            ) AS f
     ) AS fc;


-- query to get points as array latlongprice:
-- with normalized price value
-- [
-- [50.5, 30.5, 0.2], // lat, lng, intensity
-- [50.6, 30.4, 0.5]
-- ]
-- TODO: simplified geoms
with tmp as (
  select min(st_z(geom)), max(st_z(geom))
  from baro3_price
)
select array_to_json(
           array_agg(
               array[
               st_y(st_transform(geom, 4326)),
               st_x(st_transform(geom, 4326)),
               (st_z(geom) - t.min)/(t.max -t.min)
               ]
           )
       ) as price_json
from baro3_price b, tmp t;
