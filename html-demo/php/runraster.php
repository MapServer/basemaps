<?php

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

$old_path = getcwd();
chdir('../raster_process/');

// writes ramp txt: TODO: cat in shell ?
$ramp = fopen("tmpramp.txt", "w") or die("Unable to open ramp file!");
$rampTxt = '';
for ($x = 1; $x <= 5; $x++) {
    $rampTxt .= htmlspecialchars($_GET["rval$x"]) . ' ' . hex2rgb(htmlspecialchars($_GET["clr$x"])) . PHP_EOL;
}

fwrite($ramp, $rampTxt);
fclose($ramp);
chmod($ramp, 0777);

// saves current config for ran zone
$str = file_get_contents('conf.json') or die ('unable to open conf.json file !');
$json_a = json_decode($str, true);

$json_a[$_GET["selzone"]]['default'] = true;
$json_a[$_GET["selzone"]]['power'] = $_GET["power"];
$json_a[$_GET["selzone"]]['smoothing'] = $_GET["smoothing"];
$json_a[$_GET["selzone"]]['radius1'] = $_GET["radius1"];
$json_a[$_GET["selzone"]]['radius2'] = $_GET["radius2"];
$json_a[$_GET["selzone"]]['angle'] = $_GET["angle"];
for ($i=0; $i < sizeof($json_a[$_GET["selzone"]]["ramp"]); $i++) {
    $json_a[$_GET["selzone"]]["ramp"][0][0] = $_GET["rval$i"];
    $col = hex2rgb(htmlspecialchars($_GET["clr$i"]));
    $col = explode(" ", $col);
    $json_a[$_GET["selzone"]]["ramp"][0][1] = $col[0];
    $json_a[$_GET["selzone"]]["ramp"][0][2] = $col[1];
    $json_a[$_GET["selzone"]]["ramp"][0][3] = $col[2];
}

file_put_contents('conf.json', json_encode($json_a));

// params according to method
if ($_GET["method"] == 'invdist') {
    $method = htmlspecialchars($_GET["method"]) . ':radius1='. htmlspecialchars($_GET["radius1"]) .
        ':radius2='. htmlspecialchars($_GET["radius2"]) . ':smoothing='. htmlspecialchars($_GET["smoothing"]) .
        ':power='. htmlspecialchars($_GET["power"]) .
        ':angle='. htmlspecialchars($_GET["angle"]) ;
} elseif ($_GET["method"] == 'linear') {
    $method = htmlspecialchars($_GET["method"]) . ':radius='. htmlspecialchars($_GET["radius1"]);
} elseif ($_GET["method"] == 'nearest') {
    $method = htmlspecialchars($_GET["method"]) . ':radius1='. htmlspecialchars($_GET["radius1"])
        . ':radius2='. htmlspecialchars($_GET["radius2"]) .
        ':angle='. htmlspecialchars($_GET["angle"]) ;
} elseif ($_GET["method"] == 'average') {
    $method = htmlspecialchars($_GET["method"]) . ':radius1='. htmlspecialchars($_GET["radius1"])
        . ':radius2='. htmlspecialchars($_GET["radius2"]) .
        ':angle='. htmlspecialchars($_GET["angle"]) ;
} elseif ($_GET["method"] == 'invdistnn') {
    $method = htmlspecialchars($_GET["method"]) . ':radius1='. htmlspecialchars($_GET["radius1"])
        . ':power='. htmlspecialchars($_GET["power"]);
} else {
    // todo...
}

// relief asked ?
//$relief = $_GET["slope"] == 'on' ? 'slope' : '';

// current zone:
$zone = $_GET["selzone"];
//read params and relaunch script
$cmd = './process.bash ' . $method . ' ' . $zone . ' 2>&1';
$output = shell_exec($cmd);
echo "$output" . " " . $cmd
;

chdir($old_path);

//echo 'Params: method: ' . htmlspecialchars($_GET["method"]) . '\n'
//    . 'smoothing: ' . htmlspecialchars($_GET["smoothing"]);
//

?>