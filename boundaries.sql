drop table if exists tbt_tmp_rings;
drop table if exists tbt_tmp_holes;


create table tbt_tmp_rings (id serial, admin_level smallint, geometry geometry);

insert into tbt_tmp_rings(admin_level,geometry) 
   SELECT admin_level, ST_Collect(ST_ExteriorRing(geometry)) AS geometry 
   FROM (
      SELECT osm_id, admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;

create index tbt_tmp_rings_idx on tbt_tmp_rings using gist(geometry);


create table tbt_tmp_holes (id serial, admin_level smallint, geometry geometry);

create index tbt_tmp_holes_idx on tbt_tmp_holes using gist(geometry);

insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,1))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,2))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,3))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,4))FROM (
      SELECT  admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,5))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,6))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,7))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,8))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,9))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,10))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;
insert into tbt_tmp_holes(admin_level,geometry) 
SELECT admin_level, ST_Collect(ST_InteriorRingN(geometry,11))FROM (
      SELECT admin_level, (ST_Dump(geometry)).geom As geometry
      FROM osm_new_admin) As foo
   GROUP BY admin_level,osm_id;

delete from tbt_tmp_holes where geometry is null;

insert into tbt_tmp_rings (admin_level,geometry) select admin_level,geometry from tbt_tmp_holes;


create table tom_bnd_2 as (
   select c1.osm_id, st_intersection(c1.geometry,c2.geometry) as geometry
   from tbt_tmp_rings c1, tbt_tmp_rings c2
   where c1.geometry && c2.geometry and c1.osm_id!=c2.osm_id and c1.admin_level=2 and c2.admin_level=2
);
create table tom_bnd_4 as (
   select c1.osm_id, st_intersection(c1.geometry,c2.geometry) as geometry
   from tbt_tmp_rings c1, tbt_tmp_rings c2
   where c1.geometry && c2.geometry and c1.osm_id!=c2.osm_id and c1.admin_level=4 and c2.admin_level=4
);
create table tom_bnd_6 as (
   select c1.osm_id, st_intersection(c1.geometry,c2.geometry) as geometry
   from tbt_tmp_rings c1, tbt_tmp_rings c2
   where c1.geometry && c2.geometry and c1.osm_id!=c2.osm_id and c1.admin_level=6 and c2.admin_level=6
);
create table tom_bnd_8 as (
   select c1.osm_id, st_intersection(c1.geometry,c2.geometry) as geometry
   from tbt_tmp_rings c1, tbt_tmp_rings c2
   where c1.geometry && c2.geometry and c1.osm_id!=c2.osm_id and c1.admin_level=8 and c2.admin_level=8
);
