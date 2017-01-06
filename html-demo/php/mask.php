<?php
/**
 * Created by IntelliJ IDEA.
 * User: nicolas
 * Date: 04/01/2017
 * Time: 15:33
 */

$conn = pg_connect("host=localhost port=5438 dbname=osm user=nicolas password=aimelerafting");
if (!$conn) {
    echo "Une erreur de connexion bdd s'est produite.\n";
    exit;
}

$nodePath = htmlspecialchars($_GET["nodepath"]);
$query = "with tmp as (
    SELECT
      'Feature'                        AS type,
      ST_AsGeoJSON(a.geomsimple_4326, 5) :: JSON AS geometry,
      row_to_json((SELECT l FROM (SELECT node_path, values) AS l)) AS properties
    FROM administrative_boundaries a
    where a.node_path = '" . $nodePath . "'
) select row_to_json(t) as json
  from tmp t";

$result = pg_query($conn, $query);
if (!$result) {
    echo "Une erreur dans la collection s'est produite.\n";
    exit;
}

while ($data = pg_fetch_object($result)) {
    echo $data->json;
}
