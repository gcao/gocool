<?php
# regular play 
# move 1
#http://dragongoserver.sourceforge.net/game.php?g=99&a=domove&c=ab
#http://dragongoserver.sourceforge.net/game.php?gid=99&gamenotes=&message=&nextstatus=Submit+and+go+to+status&action=domove&move=0&coord=ab

# move 2
#http://dragongoserver.sourceforge.net/game.php?g=99&a=domove&c=bb
#http://dragongoserver.sourceforge.net/game.php?gid=99&gamenotes=&message=&nextstatus=Submit+and+go+to+status&action=domove&move=1&coord=bb

# move 3
#http://dragongoserver.sourceforge.net/game.php?g=99&a=domove&c=cb
#http://dragongoserver.sourceforge.net/game.php?gid=99&gamenotes=&message=&nextstatus=Submit+and+go+to+status&action=domove&move=2&coord=cb

# quick play
# move 4
# http://dragongoserver.sourceforge.net/quick_play.php?gid=99&sgf_prev=cb&sgf_move=db&color=B

# resign
#http://dragongoserver.sourceforge.net/game.php?gid=99&a=resign
#http://dragongoserver.sourceforge.net/game.php?gid=99&nextstatus=Submit+and+go+to+status&action=resign&move=0

define("SUCCESS", 0);
define("FAILURE", -1);
define("LOGIN_FAILURE", -2);
define("FIRST_MOVE_FAILURE", -3);
define("INVALID_COMMAND", -4);

define("COMMAND_PLAY", "PLAY");
define("COMMAND_RESIGN", "RESIGN");

define("DGS_HOST", "www.dragongoserver.net");

define("NONE", 0);
define("DISCUZ", 1);
define("INTEGRATION_MODE", DISCUZ);
define("DISCUZ_DIR", dirname(__FILE__)."./../../bbs_sandbox/");

class ReturnObject{
  var $code = SUCCESS, $message;
}

function get_curl($userid){
  $ch = curl_init();
  curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
  define("COOKIE_FILE_PATH", "$userid.txt");
  curl_setopt ($ch, CURLOPT_COOKIEJAR, COOKIE_FILE_PATH);
  curl_setopt ($ch, CURLOPT_COOKIEFILE, COOKIE_FILE_PATH);
  curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
  return $ch;
}

function login($ch, $userid, $passwd){
  $ret = new ReturnObject();
  $url = "http://".DGS_HOST."/login.php?quick_mode=1&userid=$userid&passwd=$passwd";
  curl_setopt ($ch, CURLOPT_URL, $url);
  $resp = curl_exec ($ch);
  if (strpos($resp, 'Ok') !== false) {
  } else {
    $ret->code = LOGIN_FAILURE;
    $ret->message = $resp;
  }
  return $ret;
}

function play($ch, $userid, $passwd, $gid, $sgf_prev, $sgf_move, $color){
  $ret = login($ch, $userid, $passwd);
  if ($ret->code == SUCCESS) {
    if ($sgf_prev == ''){
      # http://dragongoserver.sourceforge.net/game.php?g=99&a=domove&c=ab
      $url = "http://".DGS_HOST."/game.php?g=$gid&a=domove&c=$sgf_move";
      curl_setopt ($ch, CURLOPT_URL, $url);
      $resp = curl_exec($ch);
      if (strpos($resp, "game.php?gid=$gid") !== false) { # game.php?gid=$gid - text to be looked for in a success response
        # http://dragongoserver.sourceforge.net/game.php?gid=99&gamenotes=&message=&nextstatus=Submit+and+go+to+status&action=domove&move=0&coord=ab
        $url = "http://".DGS_HOST."/game.php?gid=$gid&gamenotes=&message=&nextstatus=Submit+and+go+to+status&action=domove&move=0&coord=$sgf_move";
        curl_setopt ($ch, CURLOPT_URL, $url);
        $resp = curl_exec($ch);
        if (strpos($resp, 'sectStatus') !== false) { # sectStatus - text to be looked for in a success response
          # success
        } else {
          $ret->code = FIRST_MOVE_FAILURE;
          $ret->message = $resp;
        }
      } else {
        $ret->code = FIRST_MOVE_FAILURE;
        $ret->message = $resp;
      }
    } else {
      # e.g. http://dragongoserver.sourceforge.net/quick_play.php?gid=99&sgf_prev=&sgf_move=dd&color=B
      $url = "http://".DGS_HOST."/quick_play.php?gid=$gid&sgf_prev=$sgf_prev&sgf_move=$sgf_move&color=$color";
      curl_setopt ($ch, CURLOPT_URL, $url);
      $resp = curl_exec($ch);
      if (strpos($resp, 'Ok') !== false) { # Ok - text to be looked for in a success response
        # success
      } else {
        $ret->code = FAILURE;
        $ret->message = $resp;
      }
    }
  }
  return $ret;
}

function resign($ch, $userid, $passwd, $gid, $move){
  $ret = login($ch, $userid, $passwd);
  if ($ret->code == SUCCESS) {
    $url = "http://".DGS_HOST."/game.php?gid=$gid&a=resign";
    curl_setopt ($ch, CURLOPT_URL, $url);
    $resp = curl_exec($ch);
    if (strpos($resp, "game.php?gid=$gid") !== false) { # game.php?gid=$gid - text to be looked for in a success response
      # http://dragongoserver.sourceforge.net/game.php?gid=99&nextstatus=Submit+and+go+to+status&action=resign&move=0
      $url = "http://".DGS_HOST."/game.php?gid=$gid&nextstatus=Submit+and+go+to+status&action=resign&move=$move";
      curl_setopt ($ch, CURLOPT_URL, $url);
      $resp = curl_exec($ch);
      if (strpos($resp, 'sectStatus') !== false) { # sectStatus - text to be looked for in a success response
        # success
      } else {
        $ret->code = FAILURE;
        $ret->message = $resp;
      }
    } else {
      $ret->code = FAILURE;
      $ret->message = $resp;
    }
  }
  return $ret;
}

function get_user_info(){
  if (INTEGRATION_MODE == DISCUZ){
    require_once DISCUZ_DIR.'include/common.inc.php';
    $query = $db->query("select field_1, field_2 from {$tablepre}memberfields where uid='$discuz_uid'");
    if ($memberfields = $db->fetch_array($query)) {
      return array($memberfields['field_1'], $memberfields['field_2']);
    } else {
      return NULL;
    }
  } else {
    return array($_REQUEST['userid'], $_REQUEST['passwd']);
  }
}

function render($ret){
  echo "$ret->code ".htmlspecialchars($ret->message);
}

function handle_request(){
  $ret = new ReturnObject();
  $user_info = get_user_info();
  if ($user_info === NULL){
    $ret->code = FAILURE;
    $ret->message = "Not logged into the forum.";
    render($ret);
    return;
  }
  list($userid, $passwd) = $user_info;
  if ($userid === NULL || strlen(trim($userid)) == 0 || $passwd === NULL || strlen(trim($passwd)) == 0){
    $ret->code = FAILURE;
    $ret->message = "DGS username or password is not set.";
    render($ret);
    return;
  }
  $command = $_REQUEST['command'];
  $gid = $_REQUEST['gid'];
  if ($command == COMMAND_PLAY){
    $sgf_prev = $_REQUEST['sgf_prev'];
    $sgf_move = $_REQUEST['sgf_move'];
    $color = $_REQUEST['color'];
    $ch = get_curl($userid);
    $ret = play($ch, $userid, $passwd, $gid, $sgf_prev, $sgf_move, $color);
    curl_close($ch);
  } else if ($command == COMMAND_RESIGN){
    $move = $_REQUEST['move'];
    $ch = get_curl($userid);
    $ret = resign($ch, $userid, $passwd, $gid, $move);
    curl_close($ch);
  } else {
    $ret->code = INVALID_COMMAND;
    $ret->message = $command;
  }
  render($ret);
}

handle_request();
?>