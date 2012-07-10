/*********************************************************************

   Purpose: This script will modify tables generated through the osm2pgsql
            utilility [1] into tables similar to those as generated from the 
            imposm utility [2].  The generated tables can then be used
            by the mapserver-utils utility [3].
            
            This is most likely useful for the Windows platform.
            
            [1] http://wiki.openstreetmap.org/wiki/Osm2pgsql
            [2] http://imposm.org
            [3] https://github.com/mapserver/basemaps
            
   Author:  Jeff McKenna (www.gatewaygeomatics.com)
            Michael Smith
            
   Last 
   Updated: 2012/07/10
   
   Notes:   This assumes that you already ran the osm2pgsql tool with the
            '-E 3857' switch

   Execute: psql -U postgres -d osm -f osm2pgsql-to-imposm-schema.sql
   
   Output:  The tables created will be:
   
 Schema |             Name              | Type  |
--------+-------------------------------+-------+
 public | geography_columns             | view  |
 public | geometry_columns              | view  |
 public | osm_line                      | table |
 public | osm_new_admin                 | table |
 public | osm_new_admin_view            | view  |
 public | osm_new_aeroways              | table |
 public | osm_new_aeroways_view         | view  |
 public | osm_new_amenities             | table |
 public | osm_new_amenities_view        | view  |
 public | osm_new_buildings             | table |
 public | osm_new_buildings_view        | view  |
 public | osm_new_landusages            | table |
 public | osm_new_landusages_gen0       | table |
 public | osm_new_landusages_gen0_view  | view  |
 public | osm_new_landusages_gen1       | table |
 public | osm_new_landusages_gen1_view  | view  |
 public | osm_new_landusages_view       | view  |
 public | osm_new_mainroads             | table |
 public | osm_new_mainroads_gen0        | table |
 public | osm_new_mainroads_gen0_view   | view  |
 public | osm_new_mainroads_gen1        | table |
 public | osm_new_mainroads_gen1_view   | view  |
 public | osm_new_mainroads_view        | view  |
 public | osm_new_minorroads            | table |
 public | osm_new_minorroads_view       | view  |
 public | osm_new_motorways             | table |
 public | osm_new_motorways_gen0        | table |
 public | osm_new_motorways_gen0_view   | view  |
 public | osm_new_motorways_gen1        | table |
 public | osm_new_motorways_gen1_view   | view  |
 public | osm_new_motorways_view        | view  |
 public | osm_new_places                | table |
 public | osm_new_places_view           | view  |
 public | osm_new_railways              | table |
 public | osm_new_railways_gen0         | table |
 public | osm_new_railways_gen0_view    | view  |
 public | osm_new_railways_gen1         | table |
 public | osm_new_railways_gen1_view    | view  |
 public | osm_new_railways_view         | view  |
 public | osm_new_roads                 | table |
 public | osm_new_roads_gen0            | table |
 public | osm_new_roads_gen0_view       | view  |
 public | osm_new_roads_gen1            | table |
 public | osm_new_roads_gen1_view       | view  |
 public | osm_new_roads_view            | view  |
 public | osm_new_transport_areas       | table |
 public | osm_new_transport_areas_view  | view  |
 public | osm_new_transport_points      | table |
 public | osm_new_transport_points_view | view  |
 public | osm_new_waterareas            | table |
 public | osm_new_waterareas_gen0       | table |
 public | osm_new_waterareas_gen0_view  | view  |
 public | osm_new_waterareas_gen1       | table |
 public | osm_new_waterareas_gen1_view  | view  |
 public | osm_new_waterareas_view       | view  |
 public | osm_new_waterways             | table |
 public | osm_new_waterways_view        | view  |
 public | osm_new_waterways_gen0        | table | 
 public | osm_new_waterways_gen0_view   | view  |
 public | osm_new_waterways_gen1        | table |
 public | osm_new_waterways_gen1_view   | view  |
 public | osm_point                     | table |
 public | osm_polygon                   | table |
 public | osm_roads                     | table |
 public | spatial_ref_sys               | table |
   
*********************************************************************/

------------------------------
-- ADMIN
------------------------------

DROP VIEW osm_new_admin_view;

CREATE VIEW osm_new_admin_view AS
  SELECT  row_number() OVER (ORDER BY osm_id) id, * FROM (
  SELECT osm_id, name, boundary as type, admin_level, way as geometry
  FROM osm_polygon
  WHERE boundary IN ('administrative')
  UNION ALL 
  SELECT osm_id, name, boundary as type, admin_level, way as geometry
  FROM osm_polygon
  WHERE admin_level in (
             '1',
             '2',
             '3',
             '4',
             '5',
             '6')) AS foo;             
  
DROP TABLE osm_new_admin;

CREATE TABLE osm_new_admin AS
  SELECT * FROM osm_new_admin_view;
  
ALTER TABLE osm_new_admin ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_admin_geom ON osm_new_admin USING GIST (geometry);
CLUSTER osm_new_admin_geom ON osm_new_admin;
-- add spatial constraints
ALTER TABLE osm_new_admin ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_admin ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_admin;

---------------------------------
-- AEROWAYS
---------------------------------

DROP VIEW osm_new_aeroways_view;

CREATE VIEW osm_new_aeroways_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, osm_id, name, aeroway AS type, way as geometry
 FROM osm_line 
 WHERE aeroway in ('runway',
                   'taxiway');

DROP TABLE osm_new_aeroways;

CREATE TABLE osm_new_aeroways AS
  SELECT * FROM osm_new_aeroways_view;
  
ALTER TABLE osm_new_aeroways ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_aeroways_geom ON osm_new_aeroways USING GIST (geometry);
CLUSTER osm_new_aeroways_geom ON osm_new_aeroways;
-- add spatial constraints
ALTER TABLE osm_new_aeroways ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_aeroways ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_aeroways ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_aeroways;

----------------------------
-- AMENITIES
----------------------------

DROP VIEW osm_new_amenities_view;

CREATE VIEW osm_new_amenities_view AS
  SELECT  row_number() OVER (ORDER BY osm_id) id,  osm_id, name, amenity  as type, way as geometry
  FROM osm_point
  WHERE amenity in (
            'university',
            'school',
            'library',
            'fuel',
            'hospital',
            'fire_station',
            'police',
            'townhall') ;
            
DROP TABLE osm_new_amenities;

CREATE TABLE osm_new_amenities AS
  SELECT * FROM osm_new_amenities_view;
  
ALTER TABLE osm_new_amenities ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_amenities_geom ON osm_new_amenities USING GIST (geometry);
CLUSTER osm_new_amenities_geom ON osm_new_amenities;
-- add spatial constraints
ALTER TABLE osm_new_amenities ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_amenities ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'POINT'::text OR geometry IS NULL);
ALTER TABLE osm_new_amenities ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857); 

VACUUM ANALYZE osm_new_amenities;

------------------------------
-- BUILDINGS
------------------------------

DROP VIEW osm_new_buildings_view;

CREATE VIEW osm_new_buildings_view AS
  SELECT  row_number() OVER (ORDER BY osm_id) id, osm_id, name, building as type, way as geometry
  FROM osm_polygon
  WHERE building IS NOT NULL;           
  
DROP TABLE osm_new_buildings;

CREATE TABLE osm_new_buildings AS
  SELECT * FROM osm_new_buildings_view;
  
ALTER TABLE osm_new_buildings ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_buildings_geom ON osm_new_buildings USING GIST (geometry);
CLUSTER osm_new_buildings_geom ON osm_new_buildings;
-- add spatial constraints
ALTER TABLE osm_new_buildings ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_buildings ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_buildings;

----------------------------
-- LANDUSAGES
----------------------------

DROP VIEW osm_new_landusages_view CASCADE;

CREATE VIEW osm_new_landusages_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, * FROM (
  SELECT  osm_id, name, landuse  as type, st_area(way) area , z_order, way as geometry
  FROM osm_polygon
  WHERE landuse in (
            'park',
            'forest',
            'residential',
            'retail',
            'commercial',
            'industrial',
            'railway',
            'cemetery',
            'grass',
            'farmyard',
            'farm',
            'farmland',
            'wood',
            'meadow',
            'village_green',
            'recreation_ground',
            'allotments',
            'quarry') 
  UNION ALL 
  SELECT osm_id, name, leisure as type, st_area(way) area, z_order, way as geometry
  FROM osm_polygon 
  WHERE leisure in ( 
            'park',
            'garden',
            'playground',
            'golf_course',
            'sports_centre',
            'pitch',
            'stadium',
            'common',
            'nature_reserve')
  UNION ALL 
  SELECT  osm_id, name, "natural" as type, st_area(way) area, z_order, way as geometry
  FROM osm_polygon 
  WHERE "natural" in ( 
            'wood',
            'land',
            'scrub')
  UNION ALL
  SELECT osm_id, name, highway as type, st_area(way) area, z_order, way as geometry
  FROM osm_polygon 
  WHERE "highway" in (  
            'pedestrian',  
            'footway')  
  UNION ALL 
  SELECT osm_id, name, amenity as type, st_area(way) area, z_order, way as geometry
  FROM osm_polygon 
  WHERE amenity in (  
            'university',
            'school',
            'college',
            'library',
            'fuel',
            'parking',
            'cinema',
            'theatre',
            'place_of_worship',
            'hospital')              
  )  AS foo;   
  
DROP TABLE osm_new_landusages;

CREATE TABLE osm_new_landusages AS
  SELECT * FROM osm_new_landusages_view;
  
ALTER TABLE osm_new_landusages ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_landusages_geom ON osm_new_landusages USING GIST (geometry);
CLUSTER osm_new_landusages_geom ON osm_new_landusages;
-- add spatial constraints
ALTER TABLE osm_new_landusages ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_landusages ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857); 

VACUUM ANALYZE osm_new_landusages;

----------------------------
-- LANDUSAGES_GEN0
----------------------------

DROP VIEW osm_new_landusages_gen0_view;

CREATE VIEW osm_new_landusages_gen0_view AS
  SELECT id, osm_id, name, type, area, z_order, ST_SimplifyPreserveTopology(geometry,200) AS geometry
  FROM osm_new_landusages_view 
  WHERE ST_Area(geometry)>500000;
  
DROP TABLE osm_new_landusages_gen0;

CREATE TABLE osm_new_landusages_gen0 AS
  SELECT * FROM osm_new_landusages_gen0_view;
  
ALTER TABLE osm_new_landusages_gen0 ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_landusages_gen0_geom ON osm_new_landusages_gen0 USING GIST (geometry);
CLUSTER osm_new_landusages_gen0_geom ON osm_new_landusages_gen0;
-- add spatial constraints
ALTER TABLE osm_new_landusages_gen0 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_landusages_gen0 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_landusages_gen0; 

----------------------------
-- LANDUSAGES_GEN1
----------------------------

DROP VIEW osm_new_landusages_gen1_view;

CREATE VIEW osm_new_landusages_gen1_view AS
  SELECT id, osm_id, name, type, area, z_order, ST_SimplifyPreserveTopology(geometry,50) AS geometry
  FROM osm_new_landusages_view 
  WHERE ST_Area(geometry)>50000;
  
DROP TABLE osm_new_landusages_gen1;

CREATE TABLE osm_new_landusages_gen1 AS
  SELECT * FROM osm_new_landusages_gen1_view;
  
ALTER TABLE osm_new_landusages_gen1 ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_landusages_gen1_geom ON osm_new_landusages_gen1 USING GIST (geometry);
CLUSTER osm_new_landusages_gen1_geom ON osm_new_landusages_gen1;
-- add spatial constraints
ALTER TABLE osm_new_landusages_gen1 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_landusages_gen1 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_landusages_gen1; 

---------------------------
-- MAINROADS
---------------------------

DROP VIEW osm_new_mainroads_view CASCADE;

CREATE VIEW osm_new_mainroads_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, * FROM (
  SELECT osm_id, name, highway as type, 
        CASE 
            WHEN tunnel='yes' THEN 1 
            ELSE 0 
        END tunnel,
        CASE 
            WHEN bridge='yes' THEN 1 
            ELSE 0 
        END bridge,
        CASE 
            WHEN oneway='yes' THEN 1 
            ELSE 0
        END oneway,z_order,way as geometry
  FROM osm_line WHERE highway IN ('primary',
                                  'primary_link',
                                  'secondary',
                                  'secondary_link',
                                  'tertiary')) as foo; 
  
DROP TABLE osm_new_mainroads;

CREATE TABLE osm_new_mainroads AS
  SELECT * FROM osm_new_mainroads_view;
  
ALTER TABLE osm_new_mainroads ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_mainroads_geom ON osm_new_mainroads USING GIST (geometry);
CLUSTER osm_new_mainroads_geom ON osm_new_mainroads;
-- add spatial constraints
ALTER TABLE osm_new_mainroads ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_mainroads ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_mainroads ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_mainroads;

----------------------------
-- MAINROADS_GEN0
----------------------------

DROP VIEW osm_new_mainroads_gen0_view;

CREATE VIEW osm_new_mainroads_gen0_view AS
  SELECT id, osm_id, name, type, tunnel, bridge, oneway, z_order, ST_SimplifyPreserveTopology(geometry,200) AS geometry
  FROM osm_new_mainroads_view;
  
DROP TABLE osm_new_mainroads_gen0;

CREATE TABLE osm_new_mainroads_gen0 AS
  SELECT * FROM osm_new_mainroads_gen0_view;
  
ALTER TABLE osm_new_mainroads_gen0 ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_mainroads_gen0_geom ON osm_new_mainroads_gen0 USING GIST (geometry);
CLUSTER osm_new_mainroads_gen0_geom ON osm_new_mainroads_gen0;
-- add spatial constraints
ALTER TABLE osm_new_mainroads_gen0 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_mainroads_gen0 ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_mainroads_gen0 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_mainroads_gen0;

----------------------------
-- MAINROADS_GEN1
----------------------------

DROP VIEW osm_new_mainroads_gen1_view;

CREATE VIEW osm_new_mainroads_gen1_view AS
  SELECT id, osm_id, name, type, tunnel, bridge, oneway, z_order, ST_SimplifyPreserveTopology(geometry,50) AS geometry
  FROM osm_new_mainroads_view;

DROP TABLE osm_new_mainroads_gen1;

CREATE TABLE osm_new_mainroads_gen1 AS
  SELECT * FROM osm_new_mainroads_gen1_view;
  
ALTER TABLE osm_new_mainroads_gen1 ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_mainroads_gen1_geom ON osm_new_mainroads_gen1 USING GIST (geometry);
CLUSTER osm_new_mainroads_gen1_geom ON osm_new_mainroads_gen1;
-- add spatial constraints
ALTER TABLE osm_new_mainroads_gen1 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_mainroads_gen1 ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_mainroads_gen1 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_mainroads_gen1;

----------------------------
-- MINORROADS
----------------------------

DROP VIEW osm_new_minorroads_view;

CREATE VIEW osm_new_minorroads_view AS 
  SELECT row_number() OVER (ORDER BY osm_id) id, * FROM (  
  SELECT osm_id, name, highway AS type, 
        CASE
            WHEN tunnel = 'yes'  THEN 1
            ELSE 0
        END AS tunnel, 
        CASE
            WHEN bridge = 'yes' THEN 1
            ELSE 0
        END AS bridge, 
        CASE
            WHEN oneway = 'yes' THEN 1
            ELSE 0
        END AS oneway,ref,z_order,way AS geometry
  FROM osm_line
  WHERE highway IN ('road',
                    'path',
                    'track',
                    'service',
                    'footway',
                    'bridleway',
                    'cycleway',
                    'steps',
                    'pedestrian',
                    'living_street',
                    'unclassified',
                    'residential')) as foo;  

DROP TABLE osm_new_minorroads;

CREATE TABLE osm_new_minorroads AS
  SELECT * FROM osm_new_minorroads_view;
  
ALTER TABLE osm_new_minorroads ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_minorroads_geom ON osm_new_minorroads USING GIST (geometry);
CLUSTER osm_new_minorroads_geom ON osm_new_minorroads;
-- add spatial constraints
ALTER TABLE osm_new_minorroads ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_minorroads ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_minorroads ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_minorroads;

----------------------------
-- MOTORWAYS
----------------------------

DROP VIEW osm_new_motorways_view CASCADE;

CREATE VIEW osm_new_motorways_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, osm_id, name, highway AS type, 
        CASE 
            WHEN tunnel='yes' THEN 1 
            ELSE 0 
        END tunnel,
        CASE 
            WHEN bridge='yes' THEN 1 
            ELSE 0 
        END bridge,
        CASE 
            WHEN oneway='yes' THEN 1 
            ELSE 0 
        END oneway,ref,z_order,way as geometry
 FROM osm_line WHERE highway in ('motorway',
                                 'motorway_link',
                                 'trunk',
                                 'trunk_link');

DROP TABLE osm_new_motorways;

CREATE TABLE osm_new_motorways AS
  SELECT * FROM osm_new_motorways_view;
  
ALTER TABLE osm_new_motorways ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_motorways_geom ON osm_new_motorways USING GIST (geometry);
CLUSTER osm_new_motorways_geom ON osm_new_motorways;
-- add spatial constraints
ALTER TABLE osm_new_motorways ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_motorways ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_motorways ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_motorways;

----------------------------
-- MOTORWAYS_GEN0
----------------------------

DROP VIEW osm_new_motorways_gen0_view;

CREATE VIEW osm_new_motorways_gen0_view AS
  SELECT id, osm_id, name, type, tunnel, bridge, oneway, ref, z_order, ST_SimplifyPreserveTopology(geometry,200) AS geometry
  FROM osm_new_motorways_view;
  
DROP TABLE osm_new_motorways_gen0;

CREATE TABLE osm_new_motorways_gen0 AS
  SELECT * FROM osm_new_motorways_gen0_view;
  
ALTER TABLE osm_new_motorways_gen0 ADD PRIMARY KEY (id); 

-- create spatial index
CREATE INDEX osm_new_motorways_gen0_geom ON osm_new_motorways_gen0 USING GIST (geometry);
CLUSTER osm_new_motorways_gen0_geom ON osm_new_motorways_gen0;
-- add spatial constraints
ALTER TABLE osm_new_motorways_gen0 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_motorways_gen0 ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_motorways_gen0 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_motorways_gen0;

----------------------------
-- MOTORWAYS_GEN1
----------------------------

DROP VIEW osm_new_motorways_gen1_view;

CREATE VIEW osm_new_motorways_gen1_view AS
  SELECT id, osm_id, name, type, tunnel, bridge, oneway, ref, z_order, ST_SimplifyPreserveTopology(geometry,50) AS geometry
  FROM osm_new_motorways_view;
  
DROP TABLE osm_new_motorways_gen1;

CREATE TABLE osm_new_motorways_gen1 AS
  SELECT * FROM osm_new_motorways_gen1_view;
  
ALTER TABLE osm_new_motorways_gen1 ADD PRIMARY KEY (id); 

-- create spatial index
CREATE INDEX osm_new_motorways_gen1_geom ON osm_new_motorways_gen1 USING GIST (geometry);
CLUSTER osm_new_motorways_gen1_geom ON osm_new_motorways_gen1;
-- add spatial constraints
ALTER TABLE osm_new_motorways_gen1 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_motorways_gen1 ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_motorways_gen1 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_motorways_gen1;

----------------------------
-- PLACES
----------------------------

DROP VIEW osm_new_places_view;

CREATE VIEW osm_new_places_view AS
  SELECT  row_number() OVER (ORDER BY osm_id) id,  osm_id, name, place as type, z_order, population, way as geometry
  FROM osm_point
  WHERE place in (
            'country',
            'state',
            'region',
            'county',
            'city',
            'town',
            'village',
            'hamlet',
            'suburb',
            'locality') ;
            
DROP TABLE osm_new_places;

CREATE TABLE osm_new_places AS
  SELECT * FROM osm_new_places_view;
  
-- cast population column as an integer
ALTER TABLE osm_new_places ADD COLUMN population2 integer;
UPDATE osm_new_places SET population2 = cast(population as integer) WHERE population IS NOT NULL;
ALTER TABLE osm_new_places DROP COLUMN population;
ALTER TABLE osm_new_places RENAME COLUMN population2 TO population;
  
ALTER TABLE osm_new_places ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_places_geom ON osm_new_places USING GIST (geometry);
CLUSTER osm_new_places_geom ON osm_new_places;
-- add spatial constraints
ALTER TABLE osm_new_places ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_places ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'POINT'::text OR geometry IS NULL);
ALTER TABLE osm_new_places ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857); 

VACUUM ANALYZE osm_new_places;

---------------------------------
-- RAILWAYS
---------------------------------

DROP VIEW osm_new_railways_view CASCADE;

CREATE VIEW osm_new_railways_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, osm_id, name, railway AS type, 
        CASE 
            WHEN tunnel='yes' THEN 1 
            ELSE 0 
        END tunnel,
        CASE 
            WHEN bridge='yes' THEN 1 
            ELSE 0 
        END bridge,z_order,way as geometry
 FROM osm_line WHERE railway in ('rail',
                                 'tram',
                                 'light_rail',
                                 'subway',
                                 'narrow_gauge',
                                 'preserved',
                                 'funicular',
                                 'monorail');

DROP TABLE osm_new_railways;

CREATE TABLE osm_new_railways AS
  SELECT * FROM osm_new_railways_view;
  
ALTER TABLE osm_new_railways ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_railways_geom ON osm_new_railways USING GIST (geometry);
CLUSTER osm_new_railways_geom ON osm_new_railways;
-- add spatial constraints
ALTER TABLE osm_new_railways ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_railways ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_railways ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_railways;

----------------------------
-- RAILWAYS_GEN0
----------------------------

DROP VIEW osm_new_railways_gen0_view;

CREATE VIEW osm_new_railways_gen0_view AS
  SELECT id, osm_id, name, type, tunnel, bridge, z_order, ST_SimplifyPreserveTopology(geometry,200) AS geometry
  FROM osm_new_railways_view;
  
DROP TABLE osm_new_railways_gen0;

CREATE TABLE osm_new_railways_gen0 AS
  SELECT * FROM osm_new_railways_gen0_view;
  
ALTER TABLE osm_new_railways_gen0 ADD PRIMARY KEY (id); 

-- create spatial index
CREATE INDEX osm_new_railways_gen0_geom ON osm_new_railways_gen0 USING GIST (geometry);
CLUSTER osm_new_railways_gen0_geom ON osm_new_railways_gen0;
-- add spatial constraints
ALTER TABLE osm_new_railways_gen0 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_railways_gen0 ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_railways_gen0 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_railways_gen0;

----------------------------
-- RAILWAYS_GEN1
----------------------------

DROP VIEW osm_new_railways_gen1_view;

CREATE VIEW osm_new_railways_gen1_view AS
  SELECT id, osm_id, name, type, tunnel, bridge, z_order, ST_SimplifyPreserveTopology(geometry,50) AS geometry
  FROM osm_new_railways_view;
  
DROP TABLE osm_new_railways_gen1;

CREATE TABLE osm_new_railways_gen1 AS
  SELECT * FROM osm_new_railways_gen1_view;
  
ALTER TABLE osm_new_railways_gen1 ADD PRIMARY KEY (id); 

-- create spatial index
CREATE INDEX osm_new_railways_gen1_geom ON osm_new_railways_gen1 USING GIST (geometry);
CLUSTER osm_new_railways_gen1_geom ON osm_new_railways_gen1;
-- add spatial constraints
ALTER TABLE osm_new_railways_gen1 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_railways_gen1 ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_railways_gen1 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_railways_gen1;

---------------------------
-- ROADS
---------------------------

DROP VIEW osm_new_roads_view;

CREATE VIEW osm_new_roads_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, * FROM (
  SELECT osm_id, name, bridge, NULL as ref, tunnel, oneway, z_order, type, geometry
  FROM osm_new_mainroads_view
  UNION ALL
  SELECT osm_id, name, bridge, ref, tunnel, oneway, z_order, type, geometry
  FROM osm_new_minorroads_view
  UNION ALL  
  SELECT osm_id, name, bridge, ref, tunnel, oneway, z_order, type, geometry
  FROM osm_new_motorways_view
  UNION ALL 
  SELECT osm_id, name, bridge, NULL as ref, tunnel, NULL as oneway, z_order, type, geometry
  FROM osm_new_railways_view 
  ) AS foo;
  
DROP TABLE osm_new_roads;

CREATE TABLE osm_new_roads AS
  SELECT * FROM osm_new_roads_view;
  
ALTER TABLE osm_new_roads ADD PRIMARY KEY (id);

--add CLASS column
ALTER TABLE osm_new_roads ADD COLUMN class text;
UPDATE osm_new_roads SET class = 'mainroads' WHERE type IN ('primary',
                                                            'primary_link',
                                                            'secondary',
                                                            'secondary_link',
                                                            'tertiary');
UPDATE osm_new_roads SET class = 'minorroads' WHERE type IN ('road',
                                                             'path',
                                                             'track',
                                                             'service',
                                                             'footway',
                                                             'bridleway',
                                                             'cycleway',
                                                             'steps',
                                                             'pedestrian',
                                                             'living_street',
                                                             'unclassified',
                                                             'residential');
UPDATE osm_new_roads SET class = 'motorways' WHERE type IN ('motorway',
                                                            'motorway_link',
                                                            'trunk',
                                                            'trunk_link');  
UPDATE osm_new_roads SET class = 'railways' WHERE type IN ('rail',
                                                           'tram',
                                                           'light_rail',
                                                           'subway',
                                                           'narrow_gauge',
                                                           'preserved',
                                                           'funicular',
                                                           'monorail');                                                            

-- create spatial index
CREATE INDEX osm_new_roads_geom ON osm_new_roads USING GIST (geometry);
CLUSTER osm_new_roads_geom ON osm_new_roads;
-- add spatial constraints
ALTER TABLE osm_new_roads ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_roads ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_roads ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_roads;

---------------------------
-- ROADS_GEN0
---------------------------

DROP VIEW osm_new_roads_gen0_view;

CREATE VIEW osm_new_roads_gen0_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, * FROM (
  SELECT osm_id, name, bridge, NULL as ref, tunnel, oneway, z_order, type, geometry
  FROM osm_new_mainroads_gen0_view
  UNION ALL  
  SELECT osm_id, name, bridge, ref, tunnel, oneway, z_order, type, geometry
  FROM osm_new_motorways_gen0_view
  UNION ALL 
  SELECT osm_id, name, bridge, NULL as ref, tunnel, NULL as oneway, z_order, type, geometry
  FROM osm_new_railways_gen0_view 
  ) AS foo;
  
DROP TABLE osm_new_roads_gen0;

CREATE TABLE osm_new_roads_gen0 AS
  SELECT * FROM osm_new_roads_gen0_view;
  
ALTER TABLE osm_new_roads_gen0 ADD PRIMARY KEY (id);

--add CLASS column
ALTER TABLE osm_new_roads_gen0 ADD COLUMN class text;
UPDATE osm_new_roads_gen0 SET class = 'mainroads' WHERE type IN ('primary',
                                                            'primary_link',
                                                            'secondary',
                                                            'secondary_link',
                                                            'tertiary');
UPDATE osm_new_roads_gen0 SET class = 'motorways' WHERE type IN ('motorway',
                                                            'motorway_link',
                                                            'trunk',
                                                            'trunk_link');  
UPDATE osm_new_roads_gen0 SET class = 'railways' WHERE type IN ('rail',
                                                           'tram',
                                                           'light_rail',
                                                           'subway',
                                                           'narrow_gauge',
                                                           'preserved',
                                                           'funicular',
                                                           'monorail');                                                            

-- create spatial index
CREATE INDEX osm_new_roads_gen0_geom ON osm_new_roads_gen0 USING GIST (geometry);
CLUSTER osm_new_roads_gen0_geom ON osm_new_roads_gen0;
-- add spatial constraints
ALTER TABLE osm_new_roads_gen0 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_roads_gen0 ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_roads_gen0 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_roads_gen0;

---------------------------
-- ROADS_GEN1
---------------------------

DROP VIEW osm_new_roads_gen1_view;

CREATE VIEW osm_new_roads_gen1_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, * FROM (
  SELECT osm_id, name, bridge, NULL as ref, tunnel, oneway, z_order, type, geometry
  FROM osm_new_mainroads_gen1_view
  UNION ALL  
  SELECT osm_id, name, bridge, ref, tunnel, oneway, z_order, type, geometry
  FROM osm_new_motorways_gen1_view
  UNION ALL 
  SELECT osm_id, name, bridge, NULL as ref, tunnel, NULL as oneway, z_order, type, geometry
  FROM osm_new_railways_gen1_view 
  ) AS foo;
  
DROP TABLE osm_new_roads_gen1;

CREATE TABLE osm_new_roads_gen1 AS
  SELECT * FROM osm_new_roads_gen1_view;
  
ALTER TABLE osm_new_roads_gen1 ADD PRIMARY KEY (id);

--add CLASS column
ALTER TABLE osm_new_roads_gen1 ADD COLUMN class text;
UPDATE osm_new_roads_gen1 SET class = 'mainroads' WHERE type IN ('primary',
                                                            'primary_link',
                                                            'secondary',
                                                            'secondary_link',
                                                            'tertiary');
UPDATE osm_new_roads_gen1 SET class = 'motorways' WHERE type IN ('motorway',
                                                            'motorway_link',
                                                            'trunk',
                                                            'trunk_link');  
UPDATE osm_new_roads_gen1 SET class = 'railways' WHERE type IN ('rail',
                                                           'tram',
                                                           'light_rail',
                                                           'subway',
                                                           'narrow_gauge',
                                                           'preserved',
                                                           'funicular',
                                                           'monorail');                                                            

-- create spatial index
CREATE INDEX osm_new_roads_gen1_geom ON osm_new_roads_gen1 USING GIST (geometry);
CLUSTER osm_new_roads_gen1_geom ON osm_new_roads_gen1;
-- add spatial constraints
ALTER TABLE osm_new_roads_gen1 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_roads_gen1 ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_roads_gen1 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_roads_gen1;

---------------------------------
-- TRANSPORT_AREAS
---------------------------------

DROP VIEW osm_new_transport_areas_view;

CREATE VIEW osm_new_transport_areas_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, * FROM (
  SELECT osm_id, name, railway as type,way as geometry
  FROM osm_polygon
  WHERE railway in ('station') 
  UNION ALL  
  SELECT osm_id, name, aeroway as type,way as geometry
  FROM osm_polygon 
  WHERE aeroway in ('aerodrome','terminal','helipad', 'apron')) as foo ; 
  
DROP TABLE osm_new_transport_areas;

CREATE TABLE osm_new_transport_areas AS
  SELECT * FROM osm_new_transport_areas_view;
  
ALTER TABLE osm_new_transport_areas ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_transport_areas_geom ON osm_new_transport_areas USING GIST (geometry);
CLUSTER osm_new_transport_areas_geom ON osm_new_transport_areas;
-- add spatial constraints
ALTER TABLE osm_new_transport_areas ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_transport_areas ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_transport_areas;

----------------------------
-- TRANSPORT_POINTS
----------------------------

DROP VIEW osm_new_transport_points_view;

CREATE VIEW osm_new_transport_points_view AS
  SELECT  row_number() OVER (ORDER BY osm_id) id, * FROM ( 
  SELECT osm_id, name, highway as type, ref, way as geometry
  FROM osm_point
  WHERE highway in (
            'motorway_junction',
            'turning_circle',
            'bus_stop')
  UNION ALL
  SELECT osm_id, name, railway as type, ref, way as geometry
  FROM osm_point
  WHERE railway in (
            'station',
            'halt',
            'tram_stop',
            'crossing',
            'level_crossing',
            'subway_entrance')
  UNION ALL
  SELECT osm_id, name, aeroway as type, ref, way as geometry
  FROM osm_point
  WHERE aeroway in (
            'aerodome',
            'terminal',
            'helipad',
            'gate') 
  ) AS foo;
            
DROP TABLE osm_new_transport_points;

CREATE TABLE osm_new_transport_points AS
  SELECT * FROM osm_new_transport_points_view;
  
ALTER TABLE osm_new_transport_points ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_transport_points_geom ON osm_new_transport_points USING GIST (geometry);
CLUSTER osm_new_transport_points_geom ON osm_new_transport_points;
-- add spatial constraints
ALTER TABLE osm_new_transport_points ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_transport_points ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'POINT'::text OR geometry IS NULL);
ALTER TABLE osm_new_transport_points ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857); 

VACUUM ANALYZE osm_new_transport_points;

----------------------------
-- WATERAREAS
----------------------------

DROP VIEW osm_new_waterareas_view CASCADE;

CREATE VIEW osm_new_waterareas_view AS
  SELECT row_number() OVER (ORDER BY osm_id) id, * FROM (
  SELECT  osm_id, name, waterway AS type, way AS geometry
  FROM osm_polygon
  WHERE waterway IN ('riverbank') 
  UNION ALL 
  SELECT osm_id, name, "natural" AS type, way AS geometry
  FROM osm_polygon
  WHERE "natural" IN ('water')
  UNION ALL 
  SELECT  osm_id, name, landuse AS type, way as geometry
  FROM osm_polygon
  WHERE landuse IN ('basin', 'reservoir')) AS foo;

DROP TABLE osm_new_waterareas;

CREATE TABLE osm_new_waterareas AS
  SELECT * FROM osm_new_waterareas_view;
  
ALTER TABLE osm_new_waterareas ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_waterareas_geom ON osm_new_waterareas USING GIST (geometry);
CLUSTER osm_new_waterareas_geom ON osm_new_waterareas;
-- add spatial constraints
ALTER TABLE osm_new_waterareas ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_waterareas ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_waterareas; 

----------------------------
-- WATERAREAS_GEN0
----------------------------

DROP VIEW osm_new_waterareas_gen0_view;

CREATE VIEW osm_new_waterareas_gen0_view AS
  SELECT id, osm_id, name, type, ST_SimplifyPreserveTopology(geometry,200) AS geometry
  FROM osm_new_waterareas_view where ST_Area(geometry)>500000;
  
DROP TABLE osm_new_waterareas_gen0;

CREATE TABLE osm_new_waterareas_gen0 AS
  SELECT * FROM osm_new_waterareas_gen0_view;
  
ALTER TABLE osm_new_waterareas_gen0 ADD PRIMARY KEY (id); 

-- create spatial index
CREATE INDEX osm_new_waterareas_gen0_geom ON osm_new_waterareas_gen0 USING GIST (geometry);
CLUSTER osm_new_waterareas_gen0_geom ON osm_new_waterareas_gen0;
-- add spatial constraints
ALTER TABLE osm_new_waterareas_gen0 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_waterareas_gen0 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_waterareas_gen0;

----------------------------
-- WATERAREAS_GEN1
----------------------------

DROP VIEW osm_new_waterareas_gen1_view;

CREATE VIEW osm_new_waterareas_gen1_view AS
  SELECT id, osm_id, name, type, ST_SimplifyPreserveTopology(geometry,50) AS geometry
  FROM osm_new_waterareas_view where ST_Area(geometry)>50000;
  
DROP TABLE osm_new_waterareas_gen1;

CREATE TABLE osm_new_waterareas_gen1 AS
  SELECT * FROM osm_new_waterareas_gen1_view;
  
ALTER TABLE osm_new_waterareas_gen1 ADD PRIMARY KEY (id); 

-- create spatial index
CREATE INDEX osm_new_waterareas_gen1_geom ON osm_new_waterareas_gen1 USING GIST (geometry);
CLUSTER osm_new_waterareas_gen1_geom ON osm_new_waterareas_gen1;
-- add spatial constraints
ALTER TABLE osm_new_waterareas_gen1 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_waterareas_gen1 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_waterareas_gen1;

----------------------------
-- WATERWAYS
----------------------------

DROP VIEW osm_new_waterways_view;

CREATE VIEW osm_new_waterways_view AS
  SELECT  row_number() OVER (ORDER BY osm_id) id, osm_id, name, waterway as type, way as geometry
  FROM osm_line
  WHERE waterway in (
            'stream',
            'river',
            'canal',
            'drain');

DROP TABLE osm_new_waterways;

CREATE TABLE osm_new_waterways AS
  SELECT * FROM osm_new_waterways_view;
  
ALTER TABLE osm_new_waterways ADD PRIMARY KEY (id);

-- create spatial index
CREATE INDEX osm_new_waterways_geom ON osm_new_waterways USING GIST (geometry);
CLUSTER osm_new_waterways_geom ON osm_new_waterways;
-- add spatial constraints
ALTER TABLE osm_new_waterways ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_waterways ADD CONSTRAINT enforce_geotype_geometry CHECK (geometrytype(geometry) = 'LINESTRING'::text OR geometry IS NULL);
ALTER TABLE osm_new_waterways ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_waterways;

----------------------------
-- WATERWAYS_GEN0
----------------------------

DROP VIEW osm_new_waterways_gen0_view;

CREATE VIEW osm_new_waterways_gen0_view AS
  SELECT id, osm_id, name, type, ST_SimplifyPreserveTopology(geometry,200) AS geometry
  FROM osm_new_waterways_view;
  
DROP TABLE osm_new_waterways_gen0;

CREATE TABLE osm_new_waterways_gen0 AS
  SELECT * FROM osm_new_waterways_gen0_view;
  
ALTER TABLE osm_new_waterways_gen0 ADD PRIMARY KEY (id); 

-- create spatial index
CREATE INDEX osm_new_waterways_gen0_geom ON osm_new_waterways_gen0 USING GIST (geometry);
CLUSTER osm_new_waterways_gen0_geom ON osm_new_waterways_gen0;
-- add spatial constraints
ALTER TABLE osm_new_waterways_gen0 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_waterways_gen0 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_waterways_gen0;

----------------------------
-- WATERWAYS_GEN1
----------------------------

DROP VIEW osm_new_waterways_gen1_view;

CREATE VIEW osm_new_waterways_gen1_view AS
  SELECT id, osm_id, name, type, ST_SimplifyPreserveTopology(geometry,50) AS geometry
  FROM osm_new_waterways_view;
  
DROP TABLE osm_new_waterways_gen1;

CREATE TABLE osm_new_waterways_gen1 AS
  SELECT * FROM osm_new_waterways_gen1_view;
  
ALTER TABLE osm_new_waterways_gen1 ADD PRIMARY KEY (id); 

-- create spatial index
CREATE INDEX osm_new_waterways_gen1_geom ON osm_new_waterways_gen1 USING GIST (geometry);
CLUSTER osm_new_waterways_gen1_geom ON osm_new_waterways_gen1;
-- add spatial constraints
ALTER TABLE osm_new_waterways_gen1 ADD CONSTRAINT enforce_dims_geometry CHECK (st_ndims(geometry) = 2);
ALTER TABLE osm_new_waterways_gen1 ADD CONSTRAINT enforce_srid_geometry CHECK (st_srid(geometry) = 3857);

VACUUM ANALYZE osm_new_waterways_gen1;
