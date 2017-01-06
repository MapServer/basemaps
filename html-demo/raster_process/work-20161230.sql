-- 30 dec 2016:
-- integration data fontainebleau (77186)
--

drop table if exists price_font;
CREATE TABLE price_font (
  id int,
  source text,
  source_id int,
  house_type int,
  created_on date,
  price float,
  part_count int,
  surface float,
  land_surface float,
  parking boolean,
  lift boolean,
  floor int,
  extra text,
  active boolean,
  geom geometry(point, 900913),
  real_price float,
  adminzone_id int,
  building_period text,
  building_year text,
  kept_for_testing boolean,
  raw_observation_id int8,
  geometry_quality int
);


copy price_font (id, source, source_id, house_type, created_on, price, part_count, surface, land_surface, parking, lift,
                 floor, extra, active, geom, real_price, adminzone_id, building_period,
                 building_year, kept_for_testing, raw_observation_id, geometry_quality)
    from '/Volumes/gro/Projets/efficity/heatmap/data/fontainbleau.csv'
with (format csv, header true);

ALTER TABLE price_font
  ALTER COLUMN geom TYPE GEOMETRY(POINTZ, 3857) USING st_setSRID(st_makePoint(st_x(geom), st_y(geom), price::float/surface::float), 3857);

create index price_font_geom_gist on price_font USING gist(geom);

VACUUM ANALYSE price_font;

-- que les points avec c22 (geometry_quality) = 3

delete from price_font
where c22::int < 3;
-- aucune.

-- min/max prices:
select min(price::float/surface::float), max(price::float/surface::float),
  avg(price::float/surface::float), min(st_z(geom)), max(st_z(geom))
from price_font;

select * from price_font where c6::float >= 1305987076.26742;

select * from price_font order by price desc;

delete from price_font where id in (29793644,29793621,29793866);

-- fontainebleau commune:
select geom from administrative_boundaries where code_insee = '77186';

-- TODO: 5 classes de valeurs:

-- array of points for heatmap fontainebleau:
with tmp as (
  select min(st_z(geom)), max(st_z(geom))
  from price_font
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
from price_font b, tmp t;

-- streets json:
SELECT row_to_json(fc)
FROM (
       SELECT
         'FeatureCollection'         AS type,
         array_to_json(array_agg(f)) AS features
       FROM (
              SELECT
                'Feature'                                     AS type,
                ST_AsGeoJSON(st_transform(b.geom, 4326), 5) :: JSON    AS geometry,
                row_to_json((SELECT l
                             FROM (SELECT
                                     b.id,
                                     b.price/b.surface::float as price_m2) AS l)) AS properties
              FROM price_font b
            ) AS f
     ) AS fc;


select st_asewkt(geom), id, (price/surface::float) as price_m2 from price_font;

-- sample data:
select * from samplepg;
select * from samplept;


alter table samplept add column id serial PRIMARY key;

alter table samplepg rename column "GEOMETRY" to geom;
alter table samplept rename column "GEOMETRY" to geom;

ALTER TABLE samplept ALTER COLUMN geom TYPE geometry(POINTZ, 3857) USING st_setSRID(st_makePoint(st_x(geom), st_y(geom), price::float), 3857);
ALTER TABLE samplepg ALTER COLUMN geom TYPE geometry(POlygon, 3857) USING st_setSRID(geom, 3857);

select min(price), avg(price), max(price)
from samplept;
-- 213	304.8695652173913043	403
select st_extent(geom) from samplept;

select st_delaunaytriangles(st_union(geom))
from samplept;
