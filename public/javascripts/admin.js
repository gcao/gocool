jQuery(document).ready(function(){
  if (window.location.pathname.match(/admin\/games/)) {
    logMessage('matched admin/games');
    playerSuggest();
  }
});

function playerSuggest() {
  jQuery(".form input[name='record[black_id]']").livequery(function(){
    logMessage('playerSuggest livequery');
    jQuery(this).autocomplete("#", {
      makeUrl: function(q) {
        if (jQuery.trim(q).length == 0) return;
        //var platform = jQuery(this).parents('.form').children("select[name='record[gaming_platform_id]']").val();
        var platform = 'KGS';
        return playerSuggestUrl + "?name=" + q + "&platform_id=" + platform;
      },
      minChars:1,
      matchSubset:1,
      matchContains:1,
      mustMatch:0,
      cacheLength:1,
      autoFill:true,
      selectFirst:true,
      selectOny:true
    });
  });
}
