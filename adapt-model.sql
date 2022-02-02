-- 01 dec 2016:
-- queries to adapt imposm3 existing model for these scripts:

-- table osm_railways:
-- "railways": {
-- "source": "roads",
-- "sql_filter": "type IN ('rail', 'tram', 'light_rail', 'subway', 'narrow_gauge', 'preserved', 'funicular', 'monorail')",
-- "tolerance": 50.0
-- },

drop table if exists osm_railways;
create table osm_railways as (
  SELECT *
  FROM osm_roads
  WHERE type IN ('rail', 'tram', 'light_rail', 'subway', 'narrow_gauge', 'preserved', 'funicular', 'monorail')
);

alter table osm_railways add PRIMARY KEY (id);
create index osm_railways_geometry_gist on osm_railways USING GIST (geometry);

-- generalized versions:
drop table if exists osm_railways_gen0;
create table osm_railways_gen0 as (
  SELECT
    id,
    osm_id,
    type,
    name,
    tunnel,
    bridge,
    oneway,
    ref,
    z_order,
    access,
    service,
    class,
    st_simplify(geometry, 200) as geometry
  FROM osm_railways
);

alter table osm_railways_gen0 add PRIMARY KEY (id);
create index osm_railways_gen0_geometry_gist on osm_railways_gen0 USING GIST (geometry);

drop table if exists osm_railways_gen1;
create table osm_railways_gen1 as (
  SELECT
    id,
    osm_id,
    type,
    name,
    tunnel,
    bridge,
    oneway,
    ref,
    z_order,
    access,
    service,
    class,
    st_simplify(geometry, 50) as geometry
  FROM osm_railways
);

alter table osm_railways_gen1 add PRIMARY KEY (id);
create index osm_railways_gen1_geometry_gist on osm_railways_gen1 USING GIST (geometry);

VACUUM ANALYSE osm_railways;
VACUUM ANALYSE osm_railways_gen0;
VACUUM ANALYSE osm_railways_gen1;

-- TODO: create indexes on tables !
-- type and name on all tables

create index osm_admin_type_idx on osm_admin(type);
create index osm_aeroways_type_idx on osm_aeroways(type);
create index osm_amenities_type_idx on osm_amenities(type);
create index osm_barrierpoints_type_idx on osm_barrierpoints(type);
create index osm_barrierways_type_idx on osm_barrierways(type);
create index osm_housenumbers_type_idx on osm_housenumbers(type);
create index osm_housenumbers_interpolated_type_idx on osm_housenumbers_interpolated(type);
create index osm_landusages_type_idx on osm_landusages(type);
create index osm_landusages_gen0_type_idx on osm_landusages_gen0(type);
create index osm_landusages_gen1_type_idx on osm_landusages_gen1(type);
create index osm_places_type_idx on osm_places(type);
create index osm_railways_type_idx on osm_railways(type);
create index osm_railways_gen0_type_idx on osm_railways_gen0(type);
create index osm_railways_gen1_type_idx on osm_railways_gen1(type);
create index osm_roads_type_idx on osm_roads(type);
create index osm_roads_gen0_type_idx on osm_roads_gen0(type);
create index osm_roads_gen1_type_idx on osm_roads_gen1(type);
create index osm_transport_areas_type_idx on osm_transport_areas(type);
create index osm_transport_points_type_idx on osm_transport_points(type);
create index osm_waterareas_type_idx on osm_waterareas(type);
create index osm_waterareas_gen0_type_idx on osm_waterareas_gen0(type);
create index osm_waterareas_gen1_type_idx on osm_waterareas_gen1(type);
create index osm_waterways_type_idx on osm_waterways(type);
create index osm_waterways_gen0_type_idx on osm_waterways_gen0(type);
create index osm_waterways_gen1_type_idx on osm_waterways_gen1(type);

create index osm_buildings_type_idx on osm_buildings(type);

create index osm_admin_name_idx on osm_admin(name);
create index osm_aeroways_name_idx on osm_aeroways(name);
create index osm_amenities_name_idx on osm_amenities(name);
create index osm_barrierpoints_name_idx on osm_barrierpoints(name);
create index osm_barrierways_name_idx on osm_barrierways(name);
create index osm_housenumbers_name_idx on osm_housenumbers(name);
create index osm_housenumbers_interpolated_name_idx on osm_housenumbers_interpolated(name);
create index osm_landusages_name_idx on osm_landusages(name);
create index osm_landusages_gen0_name_idx on osm_landusages_gen0(name);
create index osm_landusages_gen1_name_idx on osm_landusages_gen1(name);
create index osm_places_name_idx on osm_places(name);
create index osm_railways_name_idx on osm_railways(name);
create index osm_railways_gen0_name_idx on osm_railways_gen0(name);
create index osm_railways_gen1_name_idx on osm_railways_gen1(name);
create index osm_roads_name_idx on osm_roads(name);
create index osm_roads_gen0_name_idx on osm_roads_gen0(name);
create index osm_roads_gen1_name_idx on osm_roads_gen1(name);
create index osm_transport_areas_name_idx on osm_transport_areas(name);
create index osm_transport_points_name_idx on osm_transport_points(name);
create index osm_waterareas_name_idx on osm_waterareas(name);
create index osm_waterareas_gen0_name_idx on osm_waterareas_gen0(name);
create index osm_waterareas_gen1_name_idx on osm_waterareas_gen1(name);
create index osm_waterways_name_idx on osm_waterways(name);
create index osm_waterways_gen0_name_idx on osm_waterways_gen0(name);
create index osm_waterways_gen1_name_idx on osm_waterways_gen1(name);

create index osm_buildings_name_idx on osm_buildings(name);

VACUUM ANALYSE osm_admin;
VACUUM ANALYSE osm_aeroways;
VACUUM ANALYSE osm_amenities;
VACUUM ANALYSE osm_barrierpoints;
VACUUM ANALYSE osm_barrierways;
VACUUM ANALYSE osm_housenumbers;
VACUUM ANALYSE osm_housenumbers_interpolated;
VACUUM ANALYSE osm_landusages;
VACUUM ANALYSE osm_landusages_gen0;
VACUUM ANALYSE osm_landusages_gen1;
VACUUM ANALYSE osm_places;
VACUUM ANALYSE osm_railways;
VACUUM ANALYSE osm_railways_gen0;
VACUUM ANALYSE osm_railways_gen1;
VACUUM ANALYSE osm_roads;
VACUUM ANALYSE osm_roads_gen0;
VACUUM ANALYSE osm_roads_gen1;
VACUUM ANALYSE osm_transport_areas;
VACUUM ANALYSE osm_transport_points;
VACUUM ANALYSE osm_waterareas;
VACUUM ANALYSE osm_waterareas_gen0;
VACUUM ANALYSE osm_waterareas_gen1;
VACUUM ANALYSE osm_waterways;
VACUUM ANALYSE osm_waterways_gen0;
VACUUM ANALYSE osm_waterways_gen1;

VACUUM ANALYSE osm_buildings;

-- 01 fevrier 2022
-- reproject...
select format('alter table %I.%I alter column %I type geometry(%s, 3857) using st_transform(st_setSRID(%I, 4326), 3857);',
    f_table_schema, f_table_name, f_geometry_column, type, f_geometry_column)
from geometry_columns;

alter table public.osm_waterareas_gen1 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_waterways alter column geometry type geometry(LINESTRING, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_aeroways alter column geometry type geometry(LINESTRING, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_amenities alter column geometry type geometry(POINT, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_landusages alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_barrierpoints alter column geometry type geometry(POINT, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_transport_points alter column geometry type geometry(POINT, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_housenumbers alter column geometry type geometry(POINT, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_waterareas_gen0 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_waterways_gen0 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_landusages_gen0 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_roads_gen0 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_railways alter column geometry type geometry(LINESTRING, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_railways_gen0 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_railways_gen1 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_barrierways alter column geometry type geometry(LINESTRING, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_transport_areas alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_housenumbers_interpolated alter column geometry type geometry(LINESTRING, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_roads alter column geometry type geometry(LINESTRING, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_buildings alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_places alter column geometry type geometry(POINT, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_admin alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_waterareas alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_roads_gen1 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_waterways_gen1 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
alter table public.osm_landusages_gen1 alter column geometry type geometry(GEOMETRY, 3857) using st_transform(st_setSRID(geometry, 4326), 3857);
