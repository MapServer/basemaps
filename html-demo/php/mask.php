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
$query = "select st_asgeojson(a.geomsimple_4326, 5) as geojson
          from administrative_boundaries a
          where a.node_path = '" . $nodePath . "'";

$result = pg_query($conn, $query);
if (!$result) {
    echo "Une erreur dans la collection s'est produite.\n";
    exit;
}

while ($data = pg_fetch_object($result)) {
    echo $data->geojson;
}
