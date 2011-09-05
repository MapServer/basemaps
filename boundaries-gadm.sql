drop table if exists gadm_tmp_rings;
drop table if exists gadm_tmp_rings1;



create table gadm_tmp_rings1 (id integer, geometry geometry);
create table gadm_tmp_rings (gid serial, id integer, geometry geometry);
insert into gadm_tmp_rings1 (id,geometry) select gid, (st_dump(geometry)).geom from lev0;

insert into gadm_tmp_rings(id,geometry) 
   SELECT id as id ,ST_ExteriorRing(geometry) AS geometry from gadm_tmp_rings1;


insert into gadm_tmp_rings (id,geometry) 
   select id, ST_InteriorRingN(geometry, generate_series(1, ST_NumInteriorRing(geometry))) as geometry
   from gadm_tmp_rings1;

create index gadm_tmp_rings_idx on gadm_tmp_rings using gist(geometry);
cluster gadm_tmp_rings_idx on gadm_tmp_rings;

delete from gadm_tmp_rings t1 using gadm_tmp_rings t2
where t1.id <> t2.id
and st_disjoint(t1.geometry, t2.geometry);

vacuum analyze;

drop table if exists gadm_boundaries;

create table gadm_boundaries as (
   select c1.id::text||'_'||c2.id::text as id, st_intersection(c1.geometry,c2.geometry) as geometry
   from gadm_tmp_rings c1, gadm_tmp_rings c2
   where c1.geometry && c2.geometry and c1.id>c2.id
);

delete from gadm_boundaries WHERE st_geometrytype(geometry)!='ST_LineString' and st_geometrytype(geometry)!='ST_MultiLineString';

update gadm_boundaries set geometry = st_linemerge(geometry);

create index gadm_bnd_idx on gadm_boundaries using gist(geometry);
delete from gadm_boundaries where st_isempty(geometry);

