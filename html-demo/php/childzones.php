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

$nodePath = htmlspecialchars($_GET["nodepath"]);
$query = "SELECT row_to_json(fc)
FROM (
    SELECT
         'FeatureCollection'         AS type,
         array_to_json(array_agg(f)) AS features
       FROM (
           SELECT
                'Feature'                        AS type,
                ST_AsGeoJSON(a.geomsimple_4326, 5) :: JSON AS geometry,
                row_to_json((SELECT l FROM (SELECT a.id, a.name, a.admin_level, node_path) AS l)) AS properties
              FROM administrative_boundaries a
              where a.node_path ~ '" . $nodePath . ".*{1}'
            ) AS f
     ) AS fc";

$queryNeigh = "SELECT row_to_json(fc)
FROM (
       SELECT
         'FeatureCollection'         AS type,
         array_to_json(array_agg(f)) AS features
       FROM (
              SELECT
                'Feature'                        AS type,
                ST_AsGeoJSON(a.geomsimple_4326, 5) :: JSON AS geometry,
                row_to_json((SELECT l FROM (SELECT a.id, a.name, a.admin_level, node_path) AS l)) AS properties
              FROM administrative_boundaries a, 
              (select admin_level, geomsimple_4326 from administrative_boundaries where node_path = '" . $nodePath. "') as t
              where a.node_path <> '" . $nodePath. "' and a.admin_level = t.admin_level and st_intersects(a.geomsimple_4326, t.geomsimple_4326)
            ) AS f
     ) AS fc";

if (htmlspecialchars($_GET["neigh"]) == 'true') {
    $result = pg_query($conn, $queryNeigh);

} else {
    $result = pg_query($conn, $query);
}

if (!$result) {
    echo "Une erreur dans la collection s'est produite.\n";
    exit;
}

while ($data = pg_fetch_object($result)) {
    echo $data->row_to_json;
}
