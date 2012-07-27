<?php 
$name = "Jsgameviewer";
$version = "1.0a";
$longName = $name . $version;
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="/jsgameviewer/view/default.css"/>

<script src="/jsgameviewer/js/zh_cn.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/en_us.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/jquery-1.3.2.min.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/thickbox.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/base.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/model.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/parser.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/controller.js" type="text/javascript"></script>
<script src="/jsgameviewer/view/js/view.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/updater.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/player.js" type="text/javascript"></script>
<script src="/jsgameviewer/js/gocool.js" type="text/javascript"></script>
<title><?php echo $longName?></title>
<style type="text/css">
<!--
body {
	margin-left: 2px;
	margin-top: 2px;
}
.style1 {
	font-size: xx-large;
	font-weight: bold;
}
.style3 {
	font-size: x-large;
	font-weight: bold;
}
.style4 {
	font-size: large
}
.style5 {
	font-size: large;
	font-weight: bold;
}
-->
</style>
</head>
<body>
<p align="center"><span class="style1"><?php echo $longName?></span></p>
<p class="style3">Introduction</p>
<p><?php echo $name?>Jsgameviewer is an AJAX based game viewer which supports Go(Weiqi), <a href="http://www.daoqigame.com/">Daoqi</a>.</p>
<p class="style3"><a href="http://www.daoqigame.com/wiki-1.7.1/index.php?title=Jsgameviewer">Design Notes</a></p>
<p align="left" class="style3">Features</p>
<ul>
	<li>Support Go, <a href="http://www.daoqigame.com">Daoqi</a>;</li>
	<li>Support navigation through keyboard or mouse;</li>
	<li>Open games from URL;</li>
	<li>Play games created on DGS;</li>
	<li>...</li>
</ul>
<p align="left" class="style3">Integrate jsgameviewer into a website</p>
<?php 
$container = "gvcontainer1";
$scripts = array(
//  "new GameController().show();",
	"new GameController().setGameType(jsGameViewer.DAOQI).load('/jsgameviewer/examples/games/testmarks.sgf');",
//	"new GameController({container:'gvcontainer1'}).load('/jsgameviewer/examples/games/test4.sgf');",
//	"new GameController().load('/jsgameviewer/php/proxy.php?charset=gb2312&url=http://weiqi.spbrts.tom.com/qipu/200712/20cn-ming-f-3sgf.htm').setObserverInterval(20).startUpdater().saveSession('/jsgameviewer/index.php',10);",
//	"new GameController().createDGSPlayer().setUsername('appoolloo').loadDGSGame(388918).setPlayerInterval(8).startUpdater();"
);
foreach($scripts as $script){
?>
<pre>
&lt;script language='JavaScript'&gt;<?php echo $script; ?>&lt;/script&gt;
</pre>
<div id="<?php echo $container;?>">
<script language='JavaScript'><?php echo $script; ?></script>
</div>
<?php } ?>
<p align="left">&nbsp;</p>
<p class="style3">Credits</p>
<p align="left"><a href="http://www.jquery.orgt">jQuery</a>: Easy-to-use lightweight Javascript framework.<br>
	<a href="http://jquery.com/demo/thickbox/">ThickBox</a>: jQuery plugin<br>
	<a href="http://rakaz.nl/">Niels Leenheer</a>: Web designer, his javascript compressing code is used in jsgameviewer.<br>
	<a href="http://www.troywolf.com/articles">Troy Wolf</a>: Web designer. Jsgameviewer reused his class_php and proxy.php.<br>
	<a href="http://qgo.sourceforge.net/">qGo</a>: Open source go program that supports reviewing and playing games. Jsgameviewer reused its SGF parser code.<br>
	<a href="http://www.getfirebug.com/">Firebug</a>: Web page debugging tool.<br>
</p>
</body>
</html>
