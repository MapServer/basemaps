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

$nodePath = htmlspecialchars($_GET["nodepath"]);
$query = "with tmp as (
    SELECT DISTINCT replace('#' || substring(replace(layer, '-BLACK', ''), 2), '-', '') as clr,
      layer

    FROM entities
), tmp1 as (
    SELECT
      t.*,
      row_number()
      OVER () AS id
    FROM tmp t
) select 'Layer '||t.layer as name,' <input class=\"big\" type=\"color\" id=\"clr'||t.id||'\" name=\"clr'||t.id||'\" value=\"'||t.clr|| '\"><br/>' as frag
from tmp1 t";

$result = pg_query($conn, $query);

if (!$result) {
    echo "Une erreur dans la collection s'est produite.\n";
    exit;
}

echo '<table style="border: solid black 1px;"><tr><th>name</th><th>color</th><th>target name</th></tr>';
while ($data = pg_fetch_object($result)) {
    echo '<tr><td>' . $data->name . '</td><td>' . $data->frag . '</td><td>  <input type="text"></td></tr>';
}
echo '</table>';
