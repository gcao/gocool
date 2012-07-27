<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><?php print $_GET['template'] ?></title>
<link rel="stylesheet" href="../view/default.css"/>
</head>
<body>
<?php include "../view/templates/{$_GET['template']}.html" ?>
</body>
</html>
