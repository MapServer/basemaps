-- 12 janvier 2017:
-- requetes pour la nouvelle generation raster/img:

with tmp as (
    SELECT
      a.node_path,
      nlevel(a.node_path) AS nlevel,
      st_asgeojson(ab.geomsimple_4326, 5) as json,
      ab.geom::box2d as bbox,
      a.ramp
    FROM admin_bound_values a join administrative_boundaries ab on a.node_path = ab.node_path
    ORDER BY nlevel(a.node_path), a.node_path DESC
) SELECT
    node_path,
    nlevel,
    json,
    st_xmin(bbox)::int as xmin, st_xmax(bbox)::int as xmax,
    st_ymin(bbox)::int as ymin , st_ymax(bbox)::int as ymax,
    ramp
  FROM tmp;