<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>
<link rel='stylesheet' href='/jsgameviewer/view/default.css'/>
<script language='JavaScript' type='text/javascript' src='/jsgameviewer/php/main.php'></script>
<?php 
$title = "打谱窗口";
#if (isset($_GET['title'])) {
#  $title = urldecode($_GET['title']);
#}
?>
<title><?php echo $title ?></title>
</head>
<body style='padding:0;margin:0' onLoad="self.focus();">
<script language='JavaScript'>
<?php 
$s = "var gv = new GameController(";
if (isset($_GET['type']))
  $s .= '{gameType: '.$_GET['type'].'}'; 
$s .= ").";
$s .= isset($_GET['url'])?"load('".urldecode($_GET['url'])."')" : "show()";
$s .= ";\n";
#if (isset($_GET['url']))
#  $s .= "jq(function(){if (gv.game) document.title = gv.game.getTitle();});\n";
echo $s;
?>
</script>
</body>
</html>
