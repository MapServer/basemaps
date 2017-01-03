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

function rgb2hex($rgb) {
   $hex = "#";
   $hex .= str_pad(dechex($rgb[0]), 2, "0", STR_PAD_LEFT);
   $hex .= str_pad(dechex($rgb[1]), 2, "0", STR_PAD_LEFT);
   $hex .= str_pad(dechex($rgb[2]), 2, "0", STR_PAD_LEFT);

   return $hex; // returns the hex value including the number sign (#)
}

$old_path = getcwd();
chdir('../relief_process/');

// writes ramp txt
$ramp = fopen("tmpramp.txt", "r") or die("Unable to open tmpramp.txt!");
$i=0;
$vals = [];
while(!feof($ramp)) {
    $line = fgets($ramp);
    if (strlen(trim($line)) > 0 ) {
        $a = explode(' ', $line);
        array_push($vals, array($a[0], rgb2hex(array_slice($a, 1))));
    }
}
fclose(ramp);

echo json_encode($vals);
//echo implode($vals, '|');
