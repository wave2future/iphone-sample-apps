<?php
$cachedir = '../../cache/'; // Directory to cache files in (keep outside web root)
$cacheext = 'cache'; // Extension to give cached files (usually cache, htm, txt)

$_SERVER['FULL_URL'] = 'http';
if($_SERVER['HTTPS']=='on'){$_SERVER['FULL_URL'] .=  's';}
$_SERVER['FULL_URL'] .=  '://';
if($_SERVER['SERVER_PORT']!='80') $_SERVER['FULL_URL'] .=  $_SERVER['HTTP_HOST'].':'.$_SERVER['SERVER_PORT'].$_SERVER['SCRIPT_NAME'];
else
$_SERVER['FULL_URL'] .=  $_SERVER['HTTP_HOST'].$_SERVER['SCRIPT_NAME'];
if($_SERVER['QUERY_STRING']>' '){$_SERVER['FULL_URL'] .=  '?'.$_SERVER['QUERY_STRING'];}

$page = $_SERVER['FULL_URL']; // Requested page
$cachefile = $cachedir . md5($page) . '.' . $cacheext; // Cache file to either load or create

// Now the script has run, generate a new cache file
$fp = @fopen($cachefile, 'w');

// save the contents of output buffer to the file
@fwrite($fp, ob_get_contents());
@fclose($fp);

ob_end_flush();

?>