// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require cool_games/jquery.autocomplete
//= require cool_games/jquery.date_input
//= require cool_games/jquery.form
//= require cool_games/validanguage_uncompressed
//= require cool_games/upload

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
