<?php

$_SERVER['FULL_URL'] = 'http';
if($_SERVER['HTTPS']=='on'){$_SERVER['FULL_URL'] .=  's';}
$_SERVER['FULL_URL'] .=  '://';
if($_SERVER['SERVER_PORT']!='80') $_SERVER['FULL_URL'] .=  $_SERVER['HTTP_HOST'].':'.$_SERVER['SERVER_PORT'].$_SERVER['SCRIPT_NAME'];
else
$_SERVER['FULL_URL'] .=  $_SERVER['HTTP_HOST'].$_SERVER['SCRIPT_NAME'];
if($_SERVER['QUERY_STRING']>' '){$_SERVER['FULL_URL'] .=  '?'.$_SERVER['QUERY_STRING'];}

// Settings
$cachedir = '../../cache/'; // Directory to cache files in (keep outside web root)
$cachetime = 240; // Seconds to cache files for
$cacheext = 'cache'; // Extension to give cached files (usually cache, htm, txt)

// Ignore List
$ignore_list = array();

// Script
$page = $_SERVER['FULL_URL']; // requested page
$cachefile = $cachedir . md5($page) . '.' . $cacheext; // Cache file to either load or create

$ignore_page = false;
for ($i = 0; $i < count($ignore_list); $i++) {
	$ignore_page = (strpos($page, $ignore_list[$i]) !== false) ? true : $ignore_page;
}

$cachefile_created = ((@file_exists($cachefile)) and ($ignore_page === false)) ? @filemtime($cachefile) : 0;
@clearstatcache();

// Show file from cache if still valid
if (time() - $cachetime < $cachefile_created) {
	@readfile($cachefile) or die("could not find file");
	exit();
}

// If we're still here, we need to generate a cache file
ob_start();

?>