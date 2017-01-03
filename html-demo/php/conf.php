<?php
/**
 * Created by IntelliJ IDEA.
 * User: nicolas
 * Date: 03/01/2017
 * Time: 16:46
 */

$old_path = getcwd();
chdir('../raster_process/');

$str = file_get_contents('conf.json');
$json_a = json_decode($str, true);

echo json_encode($json_a);

chdir($old_path);
