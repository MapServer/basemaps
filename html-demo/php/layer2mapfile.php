<?php
/**
 * Created by IntelliJ IDEA.
 * User: nicolas
 * Date: 05/01/2017
 * Time: 17:22
 */

function hex2rgb($hex) {
    $hex = str_replace("#", "", $hex);

    if(strlen($hex) == 3) {
        $r = hexdec(substr($hex,0,1).substr($hex,0,1));
        $g = hexdec(substr($hex,1,1).substr($hex,1,1));
        $b = hexdec(substr($hex,2,1).substr($hex,2,1));
    } else {
        $r = hexdec(substr($hex,0,2));
        $g = hexdec(substr($hex,2,2));
        $b = hexdec(substr($hex,4,2));
    }
    $rgb = array($r, $g, $b);
    return implode(" ", $rgb); // returns the rgb values separated by commas
//   return $rgb; // returns an array with the rgb values
}


$conn = pg_connect("host=localhost port=5432 dbname=quelleville user=nicolas");
if (!$conn) {
    echo "Une erreur de connexion bdd s'est produite.\n";
    exit;
}

$nodePath = htmlspecialchars($_GET["nodepath"]);
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

$ramp = fopen("../layers.inc", "w") or die("Unable to open layers file!");
$rampTxt = '';

while ($data = pg_fetch_object($result)) {
    $rampTxt = 'LAYER'.PHP_EOL;
    $rampTxt .= 'INCLUDE \'postgis.inc\''.PHP_EOL;
    $rampTxt .= 'name layer' . $data->id . PHP_EOL;
    $rampTxt .= 'DATA "geom from (select id, replace(replace(text::text, '{', ''), '}', '') as text, st_transform(geom, 3857) as geom from entities where layer = \''. $data->layer
        . '\') as foo using unique id using srid=3857" ' . PHP_EOL;
    $rampTxt .= 'LABELITEM "text"' . PHP_EOL;
    $rampTxt .= 'CLASS' . PHP_EOL;
    $rampTxt .= 'style' . PHP_EOL;
    $rampTxt .= 'outlinecolor ' . hex2rgb($data->clr) . PHP_EOL;
    $rampTxt .= 'WIDTH 2' . PHP_EOL;
    $rampTxt .= 'END' . PHP_EOL;

    $rampTxt .= 'LABEL' . PHP_EOL;
    $rampTxt .= 'COLOR ' . hex2rgb($data->clr) . PHP_EOL;
    $rampTxt .= 'OUTLINECOLOR 235 235 235' . PHP_EOL;
    $rampTxt .= 'FONT DejaVuSansBook' . PHP_EOL;
    $rampTxt .= 'TYPE truetype' . PHP_EOL;
    $rampTxt .= 'SIZE 10' . PHP_EOL;
    $rampTxt .= 'POSITION AUTO' . PHP_EOL;
    $rampTxt .= 'PARTIALS FALSE' . PHP_EOL;
    $rampTxt .= 'ANTIALIAS true' . PHP_EOL;
    $rampTxt .= 'BUFFER 2' . PHP_EOL;
    $rampTxt .= 'END' . PHP_EOL;

    $rampTxt .= 'END' . PHP_EOL;
    $rampTxt .= 'END' . PHP_EOL;
    fwrite($ramp, $rampTxt);
}

fclose($ramp);
chmod($ramp, 0777);
