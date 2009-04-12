<?php 
$name = "在线打谱程序";
$version = "1.0a";
$longName = $name . $version;
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="/jsgameviewer/view/default.css"/>
<!-- <script language="JavaScript" type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"></script> -->
<script language="JavaScript" type="text/javascript" src="/jsgameviewer/php/main.php"></script>
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
<p class="style3">简介</p>
<p><?php echo $name?>是一个基于新一代万维网技术的在线打谱程序。该程序同时支持围棋和<a href="http://www.daoqigame.com/">道棋</a>，界面美观，操作简便。该程序完全免费，无病毒或木马，用户无需安装任何插件，是围棋博客或论坛的理想打谱程序。</p>
<p class="style3"><a href="http://www.daoqigame.com/wiki-1.7.1/index.php?title=Jsgameviewer">设计与说明</a></p>
<p align="left" class="style3">主要功能</p>
<ul>
	<li>支持围棋，<a href="http://www.daoqigame.com">道棋</a>；</li>
	<li>支持键盘和鼠标操作；</li>
	<li>打开其他服务器上的棋谱文件；</li>
	<li>试下，变化图，标记</li>
	<li>...</li>
</ul>
<p align="left" class="style3">使用说明</p>
<p align="left" class="style5">鼠标操作</p>
<p align="left" class="style5">键盘操作</p>
<p align="left" class="style3">网页集成</p>
<?php 
$container = "gvcontainer1";
$scripts = array(
//	"new GameController().show();",
//	"new GameController().setGameType(DAOQI).load('/jsgameviewer/games/testmarks.sgf');",
	"new GameController().load('/jsgameviewer/games/danghu10.sgf');",
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
<p class="style3">致谢</p>
<p align="left"><a href="http://www.jquery.orgt">jQuery</a>：短小精悍但又功能全面的JavaScript程序库。<br>
	<a href="http://jquery.com/demo/thickbox/">ThickBox</a>: jQuery插件。<br>
	<a href="http://rakaz.nl/">Niels Leenheer</a>：专业图形和网页设计员，本打谱程序采用了他的JavaScript压缩代码。<br>
	<a href="http://www.troywolf.com/articles">Troy Wolf</a>：class_php 和 proxy.php
	的作者<br>
	<a href="http://www.getfirebug.com/">Firebug/Firebug Lite</a>：网页调试工具<br>
	<a href="http://qgo.sourceforge.net/">qGo</a>：免费围棋对弈和打谱程序。本打谱程序采用了它的SGF解释代码。<br>
</p>
</body>
</html>
