-- 01 dec 2016:
-- queries to adapt imposm3 existing model for these scripts:

-- table osm_railways:
-- "railways": {
-- "source": "roads",
-- "sql_filter": "type IN ('rail', 'tram', 'light_rail', 'subway', 'narrow_gauge', 'preserved', 'funicular', 'monorail')",
-- "tolerance": 50.0
-- },

drop table if exists import.osm_railways;
create table import.osm_railways as (
  SELECT *
  FROM import.osm_roads
  WHERE type IN ('rail', 'tram', 'light_rail', 'subway', 'narrow_gauge', 'preserved', 'funicular', 'monorail')
);

alter table import.osm_railways add PRIMARY KEY (id);
create index osm_railways_geometry_gist on import.osm_railways USING GIST (geometry);

-- generalized versions:
drop table if exists import.osm_railways_gen0;
create table import.osm_railways_gen0 as (
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
  FROM import.osm_railways
);

alter table import.osm_railways_gen0 add PRIMARY KEY (id);
create index osm_railways_gen0_geometry_gist on import.osm_railways_gen0 USING GIST (geometry);

drop table if exists import.osm_railways_gen1;
create table import.osm_railways_gen1 as (
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
  FROM import.osm_railways
);

alter table import.osm_railways_gen1 add PRIMARY KEY (id);
create index osm_railways_gen1_geometry_gist on import.osm_railways_gen1 USING GIST (geometry);

VACUUM ANALYSE import.osm_railways;
VACUUM ANALYSE import.osm_railways_gen0;
VACUUM ANALYSE import.osm_railways_gen1;

-- TODO: create indexes on tables !
-- type and name on all tables

create index osm_admin_type_idx on import.osm_admin(type);
create index osm_aeroways_type_idx on import.osm_aeroways(type);
create index osm_amenities_type_idx on import.osm_amenities(type);
create index osm_barrierpoints_type_idx on import.osm_barrierpoints(type);
create index osm_barrierways_type_idx on import.osm_barrierways(type);
create index osm_buildings_type_idx on import.osm_buildings(type);
create index osm_housenumbers_type_idx on import.osm_housenumbers(type);
create index osm_housenumbers_interpolated_type_idx on import.osm_housenumbers_interpolated(type);
create index osm_landusages_type_idx on import.osm_landusages(type);
create index osm_landusages_gen0_type_idx on import.osm_landusages_gen0(type);
create index osm_landusages_gen1_type_idx on import.osm_landusages_gen1(type);
create index osm_places_type_idx on import.osm_places(type);
create index osm_railways_type_idx on import.osm_railways(type);
create index osm_railways_gen0_type_idx on import.osm_railways_gen0(type);
create index osm_railways_gen1_type_idx on import.osm_railways_gen1(type);
create index osm_roads_type_idx on import.osm_roads(type);
create index osm_roads_gen0_type_idx on import.osm_roads_gen0(type);
create index osm_roads_gen1_type_idx on import.osm_roads_gen1(type);
create index osm_transport_areas_type_idx on import.osm_transport_areas(type);
create index osm_transport_points_type_idx on import.osm_transport_points(type);
create index osm_waterareas_type_idx on import.osm_waterareas(type);
create index osm_waterareas_gen0_type_idx on import.osm_waterareas_gen0(type);
create index osm_waterareas_gen1_type_idx on import.osm_waterareas_gen1(type);
create index osm_waterways_type_idx on import.osm_waterways(type);
create index osm_waterways_gen0_type_idx on import.osm_waterways_gen0(type);
create index osm_waterways_gen1_type_idx on import.osm_waterways_gen1(type);

create index osm_admin_name_idx on import.osm_admin(name);
create index osm_aeroways_name_idx on import.osm_aeroways(name);
create index osm_amenities_name_idx on import.osm_amenities(name);
create index osm_barrierpoints_name_idx on import.osm_barrierpoints(name);
create index osm_barrierways_name_idx on import.osm_barrierways(name);
create index osm_buildings_name_idx on import.osm_buildings(name);
create index osm_housenumbers_name_idx on import.osm_housenumbers(name);
create index osm_housenumbers_interpolated_name_idx on import.osm_housenumbers_interpolated(name);
create index osm_landusages_name_idx on import.osm_landusages(name);
create index osm_landusages_gen0_name_idx on import.osm_landusages_gen0(name);
create index osm_landusages_gen1_name_idx on import.osm_landusages_gen1(name);
create index osm_places_name_idx on import.osm_places(name);
create index osm_railways_name_idx on import.osm_railways(name);
create index osm_railways_gen0_name_idx on import.osm_railways_gen0(name);
create index osm_railways_gen1_name_idx on import.osm_railways_gen1(name);
create index osm_roads_name_idx on import.osm_roads(name);
create index osm_roads_gen0_name_idx on import.osm_roads_gen0(name);
create index osm_roads_gen1_name_idx on import.osm_roads_gen1(name);
create index osm_transport_areas_name_idx on import.osm_transport_areas(name);
create index osm_transport_points_name_idx on import.osm_transport_points(name);
create index osm_waterareas_name_idx on import.osm_waterareas(name);
create index osm_waterareas_gen0_name_idx on import.osm_waterareas_gen0(name);
create index osm_waterareas_gen1_name_idx on import.osm_waterareas_gen1(name);
create index osm_waterways_name_idx on import.osm_waterways(name);
create index osm_waterways_gen0_name_idx on import.osm_waterways_gen0(name);
create index osm_waterways_gen1_name_idx on import.osm_waterways_gen1(name);

VACUUM ANALYSE import.osm_admin;
VACUUM ANALYSE import.osm_aeroways;
VACUUM ANALYSE import.osm_amenities;
VACUUM ANALYSE import.osm_barrierpoints;
VACUUM ANALYSE import.osm_barrierways;
VACUUM ANALYSE import.osm_buildings;
VACUUM ANALYSE import.osm_housenumbers;
VACUUM ANALYSE import.osm_housenumbers_interpolated;
VACUUM ANALYSE import.osm_landusages;
VACUUM ANALYSE import.osm_landusages_gen0;
VACUUM ANALYSE import.osm_landusages_gen1;
VACUUM ANALYSE import.osm_places;
VACUUM ANALYSE import.osm_railways;
VACUUM ANALYSE import.osm_railways_gen0;
VACUUM ANALYSE import.osm_railways_gen1;
VACUUM ANALYSE import.osm_roads;
VACUUM ANALYSE import.osm_roads_gen0;
VACUUM ANALYSE import.osm_roads_gen1;
VACUUM ANALYSE import.osm_transport_areas;
VACUUM ANALYSE import.osm_transport_points;
VACUUM ANALYSE import.osm_waterareas;
VACUUM ANALYSE import.osm_waterareas_gen0;
VACUUM ANALYSE import.osm_waterareas_gen1;
VACUUM ANALYSE import.osm_waterways;
VACUUM ANALYSE import.osm_waterways_gen0;
VACUUM ANALYSE import.osm_waterways_gen1;