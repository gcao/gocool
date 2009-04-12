<?php
include("common.php");

$files = array(
  '../js/jquery.js',
	'../js/slider.js',
	'../js/init.js',
	'../js/config.js',
	'../js/thickbox.js',
	'../js/model.js',
	'../js/parser.js',
	'../view/js/view.js',
	'../js/controller.js',
	'../js/dgs.js'
);
combine("javascript", $files, dirname(__FILE__), true, dirname(__FILE__) . '/cache');
?>
