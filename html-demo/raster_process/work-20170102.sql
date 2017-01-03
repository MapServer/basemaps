-- 02 janvier 2017: relief generator, based on grid generator:
--

create schema newosm;

alter table osm_aeroways set schema newosm;
alter table osm_amenities set schema newosm;
alter table osm_buildings set schema newosm;
alter table osm_landusages set schema newosm;
alter table osm_railways set schema newosm;
alter table osm_transport_areas set schema newosm;
alter table osm_transport_points set schema newosm;