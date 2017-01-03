-- 03 janvier 2017:
-- price raster on new cities:
-- cf mail estelle:

-- - code_insee : le code insee de l'adminbound (ville) qui contient les obs (seulement pour les 3 villes spécifiées)
-- - price : le prix après correction par l'évolution des prix sur la commune (ie celui à prendre en compte)
-- - surface
-- - m2_price (= price / surface)
-- - is_outlier : la détermination des outliers est faite par ville et type de bien (maison/appart)
-- - is_geocoded_to_address_precision : la qualité du géocodage. On associe un point à toutes les observations, mais si on n'a pas assez d'infos ou si le géocodage échoue, c'est un point aléatoire dans la géométrie de la ville
-- - point : la géométrie (encore en ref 900913)
-- - lat / lng
-- - source : la source de l'observation (les annonces ont pour source "classifeid" ou "yanport")
-- - created_on : la date de la transaction ou de la mise en ligne de l'annonce. Pourra être utile si on ne désire prendre que les observations "récentes"
-- - land_surface : surface du terrain pour les maisons
-- - real_price : le prix avant la correction temporelle (au cas où)

select * from observations_for_carto;
select st_srid(point) from observations_for_carto;

select distinct code_insee
from observations_for_carto;

alter table observations_for_carto alter COLUMN point type geometry(point, 3857) using st_transform(point, 3857);
alter table observations_for_carto rename COLUMN point to geom;

ALTER TABLE observations_for_carto
  ALTER COLUMN geom TYPE GEOMETRY(POINTZ, 3857) USING st_setSRID(st_makePoint(st_x(geom), st_y(geom), m2_price), 3857);

create index observations_for_carto_geom_gist on observations_for_carto USING gist(geom);

VACUUM ANALYSE observations_for_carto;

-- min/max prices:
select min(m2_price), max(m2_price),
  avg(m2_price), min(st_z(geom)), max(st_z(geom)), code_insee
from observations_for_carto
group by code_insee;

-- algo for quantiles, bordel !
-- yes
with tmp as (
    SELECT
      m2_price,
      ntile(9)
      OVER (
        ORDER BY m2_price),
      row_number() over () as id
    FROM observations_for_carto o
    WHERE code_insee = '06088' and o.is_outliers
) select ntile, min(t.m2_price), max(t.m2_price), count(*)
  from tmp t
group by ntile
order by ntile;

select * from observations_for_carto
where code_insee = '06088' and is_outliers;
