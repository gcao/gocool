// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.autocomplete
//= require jquery.date_input
//= require jquery.form
//= require validanguage_uncompressed
//= require upload
jQuery(document).ready(function(){
    //arrowimages.down[1]="/assets/down.gif";
    //arrowimages.right[1]="/assets/right.gif";
    //jQuery('#myslidemenu .#' + controller_name).addClass('active');

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