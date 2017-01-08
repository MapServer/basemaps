<?php
/**
 * Created by IntelliJ IDEA.
 * User: nicolas
 * Date: 05/01/2017
 * Time: 17:22
 */

$conn = pg_connect("host=localhost port=5438 dbname=osm user=nicolas password=aimelerafting");
if (!$conn) {
    echo "Une erreur de connexion bdd s'est produite.\n";
    exit;
}

$codeInsee = htmlspecialchars($_GET["codeinsee"]);
$query = "with tmp as (
    SELECT
      'Feature'                        AS type,
      ST_AsGeoJSON(s.geomsimple_4326, 5) :: JSON AS geometry,
      row_to_json((SELECT l FROM (SELECT s.id, s.name, s.median_price_m2::int) AS l)) AS properties
    FROM baro3_streetprice s
    where s.insee_code= '" . $codeInsee . "'
), tmp1 as (
  select 'FeatureCollection'         AS type,
  array_to_json(array_agg(t)) AS features
  from tmp t
) select row_to_json(t) as json
  from tmp1 t";

$result = pg_query($conn, $query);

if (!$result) {
    echo "Une erreur dans la collection s'est produite.\n";
    exit;
}

while ($data = pg_fetch_object($result)) {
    echo $data->json;
}
