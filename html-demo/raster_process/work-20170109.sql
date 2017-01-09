-- 9 janvier 2017:
-- suite demo:

-- new geovalid field: true if enough stats for this level.
-- AJout colonne valid a admin_bound: plus de 7 points distincs => stat faisable
ALTER TABLE admin_bound_values  drop COLUMN geovalid;
ALTER TABLE admin_bound_values  ADD COLUMN geovalid BOOLEAN DEFAULT FALSE;

WITH tmp AS (
    SELECT DISTINCT ON (point) *
    FROM observations_for_carto
    WHERE NOT is_outlier
), tmp1 AS (
    SELECT
      node_path,
      count(*)
    FROM tmp
    WHERE code_insee = '44' AND NOT is_outlier and is_geocoded_to_address_precision
    GROUP BY node_path
    HAVING count(*) >= 7
) UPDATE admin_bound_values a
SET geovalid = TRUE
FROM tmp1 t
WHERE a.node_path = t.node_path;

CREATE INDEX admin_bound_values_geovalid_idx
  ON admin_bound_values (geovalid);

VACUUM ANALYSE admin_bound_values;




SELECT
  o.node_path,
  o.point,
  o.m2_price
FROM observations_for_carto o
WHERE NOT o.is_outlier AND node_path ~ '0.44.88.88528.*' AND o.is_geocoded_to_address_precision;