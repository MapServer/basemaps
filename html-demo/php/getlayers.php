<?php
/**
 * Created by IntelliJ IDEA.
 * User: nicolas
 * Date: 05/01/2017
 * Time: 17:22
 */

$conn = pg_connect("host=localhost port=5432 dbname=quelleville user=nicolas");
if (!$conn) {
    echo "Une erreur de connexion bdd s'est produite.\n";
    exit;
}

$query = "with tmp as (
    SELECT layer, replace('#' || substring(replace(layer, '-BLACK', ''), 2), '-', '') as clr, count(*) as cnt
    FROM entities
    WHERE layer is not null
  group by layer
  order by 3 desc
), tmp1 as (
    SELECT
      t.*,
      row_number()
      OVER () AS id
    FROM tmp t
) select t.id, t.layer, t.clr, t.cnt
from tmp1 t";

$result = pg_query($conn, $query);

if (!$result) {
    echo "Une erreur dans la collection s'est produite.\n";
    exit;
}

$vals = [];

while ($data = pg_fetch_object($result)) {
    array_push($vals, $data);
}

echo json_encode($vals);