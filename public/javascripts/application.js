jQuery(document).ready(function(){
  arrowimages.down[1]="/images/down.gif";
  arrowimages.right[1]="/images/right.gif";
  jQuery('#myslidemenu .#' + controller_name).addClass('active');

  if (!jQuery.browser.mozilla) jQuery('#firefox_container').show();

  jQuery("#container input[name=reset]").click(function(){
    jQuery("#container form :input[type=text], #container form textarea").val("");
  });
});

function showError(fieldId, errorMsg) {
  jQuery('#' + fieldId).addClass('failedField');
  var errorMsgId = '#' + fieldId + "_errorMsg";
  if (jQuery(errorMsgId).length > 0) {
    jQuery(errorMsgId).text(errorMsg);
  } else {
    jQuery('#' + fieldId).after('<div class="vdError"><span id="' + fieldId + '_errorMsg">' + errorMsg + '</span></div>')
  }
}

function showErrors(errors) {
  jQuery.each(errors, function(i, value){
    showError(value[0], value[1]);
  });
}

function deleteGame(gameId) {
  jQuery.post(gamesUrl + "/" + gameId, {
    _method: 'delete'
  });
  jQuery('#game_row_' + gameId).remove();
}

function deletePlayer(playerId) {
  jQuery.post(playersUrl + "/" + playerId, {
    _method: 'delete'
  });
  jQuery('#player_row_' + playerId).remove();
}

