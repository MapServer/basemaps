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

$query = "select st_asgeojson(st_transform(st_union(geom), 4326), 5) as json
from administrative_boundaries
where code_insee in ('93048', '35051', '06088')";

$result = pg_query($conn, $query);
if (!$result) {
    echo "Une erreur dans la collection s'est produite.\n";
    exit;
}

while ($data = pg_fetch_object($result)) {
    echo $data->json;
}

//echo "coucou";