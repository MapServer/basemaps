-- 04 janvier 2017: préparation de masques pour tester les rues:
--  - filaire de rue coloré par la "heatmap" (histoire qu'ils éliminent ça si ça leur plait vraiment pas du tout)
-- - bâtiments colorés par la "heatmap" en utilisant les poly de bâtiment OSM
-- - filaire + bâtiment (pour pas faire "trop vide")
-- - coloré les patés de maison ("heatmap" + filaire de rue par dessus (la carte de démo actuelle en fait))

-- masque des rues: élargies suivan leur type ?
-- pg de masque = extent - buffer rues

SELECT st_setSRID(geom :: BOX2D :: GEOMETRY, 3857)
FROM administrative_boundaries a
WHERE a.code_insee = '93048';

-- rues level 14 du mapfile:
--
DROP TABLE IF EXISTS mask_street;
CREATE TABLE mask_street AS (
  WITH tmp AS (
      SELECT code_insee, geom
      FROM administrative_boundaries a
      WHERE a.code_insee in ('93048', '35051', '06088')
  ), tmp1 AS (
      SELECT
        osm_id, code_insee,
        geometry,
        name                     AS name,
        ref,
        type || bridge || tunnel AS type
      FROM osm_roads r
        JOIN tmp t ON st_intersects(t.geom, r.geometry)
  ), tmp2 AS (
      SELECT code_insee, st_multi(st_union(CASE WHEN type IN ('unclassified00', 'residential00', 'service00', 'road00', 'living_street00',
                                                           'secondary00', 'secondary_link00',
                                                           'unclassified10', 'residential10', 'service10', 'road10', 'living_street10',
                                         'secondary10', 'secondary_link10',
                                         'unclassified01', 'residential01', 'service01', 'living_street01',
                                         'secondary01', 'secondary_link01')
        THEN st_buffer(geometry, 2.5 * 9)
                      WHEN TYPE IN ('track00')
                        THEN st_buffer(GEOMETRY, 0.75 * 9)
                      WHEN TYPE IN ('tertiary00', 'tertiary_link00',
                                    'tertiary01', 'tertiary_link01',
                                    'primary10', 'primary_link10', 'motorway_link10', 'tertiary10', 'tertiary_link10')
                        THEN st_buffer(GEOMETRY, 2 * 9)
                      WHEN TYPE IN
                           ('primary00', 'primary_link00', 'trunk_link00', 'primary01', 'primary_link01', 'motorway_link01', 'trunk_link01', 'trunk_link10')
                        THEN st_buffer(GEOMETRY, 3 * 9)
                      WHEN TYPE IN
                           ('pedestrian00', 'pedestrian01', 'footway01', 'path01', 'pedestrian10', 'footway10', 'path10')
                        THEN st_buffer(GEOMETRY, 1.5 * 9)
                      WHEN TYPE IN ('motorway00', 'trunk00', 'motorway10', 'trunk10', 'motorway01', 'trunk01')
                        THEN st_buffer(GEOMETRY, 5 * 9)
                      ELSE st_buffer(geometry, 1 * 9) END)) AS geom
      FROM tmp1 t
      GROUP BY code_insee
  ) SELECT
      code_insee,
      t2.geom :: GEOMETRY(MULTIPOLYGON, 3857) AS geom
    FROM tmp2 t2
);

-- masque batiments:
DROP TABLE IF EXISTS mask_bat;
CREATE TABLE mask_bat AS (
  WITH tmp AS (
      SELECT code_insee, geom
      FROM administrative_boundaries a
      WHERE a.code_insee in ('93048', '35051', '06088')
  ), tmp1 AS (
      SELECT code_insee, st_dump(st_union(b.geometry)) AS dmp
      FROM osm_buildings b
        JOIN tmp t ON st_intersects(t.geom, b.geometry)
      GROUP BY code_insee
  ) SELECT code_insee,
      (t.dmp).path [1] AS id,
      (t.dmp).geom
    FROM tmp1 t
);

ALTER TABLE mask_bat
  ADD COLUMN gid SERIAL PRIMARY KEY;
CREATE INDEX mask_bat_geom_gist
  ON mask_bat USING GIST (geom);
VACUUM ANALYSE mask_bat;

-- masque rue + batiment
drop table if exists mask_full;
CREATE TABLE mask_full as (
  WITH tmp AS (
      SELECT code_insee, st_union(geom) AS geom
      FROM mask_bat
      GROUP BY code_insee
  ) SELECT t1.code_insee, st_union(t1.geom, t2.geom) as geom
    FROM mask_street t1, tmp t2
    where t1.code_insee = t2.code_insee
);

-- commune mask
select st_asgeojson(st_transform(st_multi(geom), 4326), 5) as json
from administrative_boundaries
where code_insee = '93048';

-- global masks table:
drop table if exists mask;
CREATE TABLE mask as (
    select 'maskcom' as name, code_insee, geom
  from administrative_boundaries
  where code_insee in ('93048', '35051', '06088')
  UNION ALL
    select 'maskstr', code_insee, geom
    from mask_street
  UNION ALL
    select 'maskbat', code_insee, geom
    from mask_bat
  UNION ALL
    select 'maskfull', code_insee, geom
    from mask_full
);

ALTER TABLE mask ADD COLUMN gid SERIAL PRIMARY KEY;
VACUUM ANALYSE mask;

select st_asgeojson(st_transform(st_union(geom), 4326), 5) as json
from administrative_boundaries
where code_insee in ('93048', '35051', '06088');