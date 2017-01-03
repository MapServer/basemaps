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
chdir('../relief_process/');

// writes ramp txt
$ramp = fopen("tmpramp.txt", "w") or die("Unable to open ramp file!");
$rampTxt = '';
for ($x = 1; $x <= 5; $x++) {
    $rampTxt .= htmlspecialchars($_GET["rval$x"]) . ' ' . hex2rgb(htmlspecialchars($_GET["clr$x"])) . PHP_EOL;
}

fwrite($ramp, $rampTxt);
fclose($ramp);
chmod($ramp, 0777);

$params = '';
# params according to UI choices
if ($_GET["reliefcb"] == 'on') {
    $params .= 'relief=true';
} else {
    $params .= 'relief=false';
}
if ($_GET["slopecb"] == 'on') {
    $params .= ' slope=true';
} else {
    $params .= ' slope=false';
}
if ($_GET["hillshadecb"] == 'on') {
    $params .= ' hillshade=true';
} else {
    $params .= ' hillshade=false';
}

$cmd = './process_relief.bash ' . $params . ' 2>&1';
$output = shell_exec($cmd);
echo "$output" . " " . $cmd;

chdir($old_path);

?>