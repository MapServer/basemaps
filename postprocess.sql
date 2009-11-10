-- optional, makes it easier to wrap place names
update osm_point set name = replace(name,'-',' ');

-- grant our user access to the data
grant SELECT on osm_line to "www-data";
grant SELECT on osm_point to "www-data";
grant SELECT on osm_polygon to "www-data";
create or replace view osm_polygon_view as select osm_id, "natural" as nature, landuse, waterway, highway, name, way from osm_polygon;
grant select on osm_polygon_view to "www-data" ;

-- correct a few common typos
update osm_line set tunnel='yes' where tunnel='true';
update osm_line set tunnel='no' where tunnel='false';
update osm_line set tunnel='yes' where tunnel='yel';
update osm_line set bridge='yes' where bridge='true';

update osm_line set oneway='yes' where oneway='Yes';
update osm_line set oneway='yes' where oneway='true';
update osm_line set oneway='yes' where oneway='1';

-- create a few indexes on the data for speedier access
create index osm_polygon_building_idx on osm_polygon(building);
create index osm_polygon_amenity_idx on osm_polygon(amenity);
create index osm_polygon_landuse_idx on osm_polygon(landuse);
create index osm_line_highway_idx on osm_line(highway);
create index osm_line_aeroway_idx on osm_line(aeroway);
create index osm_line_railway_idx on osm_line(railway);
create index osm_line_bridge_idx on osm_line(bridge);
create index osm_polygon_leisure_idx on osm_polygon(leisure);
create index osm_polygon_aeroway_idx on osm_polygon(aeroway);
create index osm_polygon_waterway_idx on osm_polygon(waterway);
create index osm_polygon_natural_idx on osm_polygon("natural");
create index osm_point_place_idx on osm_point(place);
create index osm_line_zorder_idx on osm_line(z_order);


alter table osm_line add column priority integer;
update osm_line set priority = 10 where highway='motorway';
update osm_line set priority = 20 where highway='trunk';
update osm_line set priority = 26 where highway='trunk_link';
update osm_line set priority = 25 where highway='motorway_link';
update osm_line set priority = 30 where highway='primary';
update osm_line set priority=35 where highway='primary_link';

update osm_line set priority=40 where highway='secondary';
update osm_line set priority=45 where highway='secondary_link';

update osm_line set priority=50 where highway='tertiary';
update osm_line set priority=65 where highway='tertiary_link';

update osm_line set priority=70 where highway='residential';
update osm_line set priority=75 where highway='service';
update osm_line set priority=80 where highway='track';
update osm_line set priority=85 where highway='pedestrian';

create index line_priority_idx on osm_line(priority);

