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

// writes ramp txt
$ramp = fopen("tmpramp.txt", "w") or die("Unable to open file!");
$rampTxt = '';
for ($x = 1; $x <= 5; $x++) {
    $rampTxt .= htmlspecialchars($_GET["rval$x"]) . ' ' . hex2rgb(htmlspecialchars($_GET["clr$x"])) . PHP_EOL;
}

fwrite($ramp, $rampTxt);
fclose($ramp);
chmod($ramp, 0777);

# params according to method
if ($_GET["method"] == 'invdist') {
    $method = htmlspecialchars($_GET["method"]) . ':radius1='. htmlspecialchars($_GET["radius1"]) .
        ':radius2='. htmlspecialchars($_GET["radius2"]) . ':smoothing='. htmlspecialchars($_GET["smoothing"]) .
        ':angle='. htmlspecialchars($_GET["angle"]) ;
} elseif ($_GET["method"] == 'linear') {
    $method = htmlspecialchars($_GET["method"]) . ':radius='. htmlspecialchars($_GET["radius1"]);
} elseif ($_GET["method"] == 'nearest') {
    $method = htmlspecialchars($_GET["method"]) . ':radius1='. htmlspecialchars($_GET["radius1"])
        . ':radius2='. htmlspecialchars($_GET["radius2"]) .
        ':angle='. htmlspecialchars($_GET["angle"]) ;
} else {

}

//read params and relaunch script
$cmd = './process.bash ' . $method;
$output = shell_exec($cmd);
echo "$output";

chdir($old_path);

//echo 'Params: method: ' . htmlspecialchars($_GET["method"]) . '\n'
//    . 'smoothing: ' . htmlspecialchars($_GET["smoothing"]);
//

?>