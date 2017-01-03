<?php
/**
 * Created by IntelliJ IDEA.
 * User: nicolas
 * Date: 03/01/2017
 * Time: 22:06
 */

$old_path = getcwd();
chdir('../relief_process/');

$cmd = './rasterinfo.bash ' . $params . ' 2>&1';
$output = shell_exec($cmd);

// TODO.... :D
$res = trim(str_replace('STATISTICS_MINIMUM=', '', str_replace('STATISTICS_MEAN=', '',
    str_replace('STATISTICS_MAXIMUM=', '', str_replace('null ', '', str_replace(array("\r\n", "\r", "\n", "\\n", "\t", "    "), ' ', $output))))));
$res = str_replace('  ', ' ', $res);
$res = explode(' ', $res);

chdir($old_path);

// returns info as json
$ret = [];
$ret['max'] = $res[0];
$ret['avg'] = intval($res[1]);
$ret['min'] = $res[2];

echo json_encode($ret);
//echo print_r($res);
