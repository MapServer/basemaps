-- 12 janvier 2017:
-- SQL pour générer les masques de chaque zone, en enlevant les landusages a exclure:
--
-- TODO: liste des tags OSM retenus et surfaces min et max retenues a discuter avec EFFI:
--
-- Landusage (pg)
select distinct type from newosm.osm_landusages;

drop table if exists zone_mask;
create table zone_mask as (
  with tmp as (
      SELECT
        ab.id,
        ab.node_path,
        ab.geom
      FROM administrative_boundaries ab
      where ab.node_path ~ '0.44.*'
  ), tmp1 as (
      SELECT  l.geometry
      FROM newosm.osm_landusages l
      WHERE l.type IN ('museum', 'hospital', 'aerodrome', 'archaeological_site',
                       'embassy', 'helipad', 'prison', 'university', 'college')
            AND st_area(l.geometry) BETWEEN 10000 AND 50000000

  ), tmp2 as (
      SELECT t.id,
        t.node_path, t.geom,
        st_union(l.geometry) AS geomunion
      FROM tmp t LEFT JOIN tmp1 l ON (st_intersects(t.geom, l.geometry))
      group by t.id, t.node_path, t.geom
  ) select id, node_path,
      st_transform(
          st_simplifypreservetopology(
              st_multi(
                  st_difference(
                      geom,
                      coalesce(geomunion, 'GEOMETRYCOLLECTION EMPTY'::geometry)
                  )
              )::geometry(MULTIPOLYGON, 3857),
              case when nlevel(node_path) = 2 then 1000
              when nlevel(node_path) = 3 then 500
              else 50 end), 4326
      ) as geommask
    from tmp2 t
);

alter table zone_mask add PRIMARY KEY (node_path);
create index zone_mask_node_path_gist on zone_mask USING gist(node_path);
VACUUM ANALYSE zone_mask;

-- nouvelle requete script bash
SELECT
  a.node_path,
  nlevel(a.node_path) AS nlevel,
  st_asgeojson(a.geommask, 5) as json,
  st_xmin(a.geommask::box2d)::int as xmin, st_xmax(a.geommask::box2d)::int as xmax,
  st_ymin(a.geommask::box2d)::int as ymin , st_ymax(a.geommask::box2d)::int as ymax,
  ab.ramp
FROM zone_mask a join admin_bound_values ab on a.node_path = ab.node_path
ORDER BY nlevel(a.node_path), a.node_path DESC;