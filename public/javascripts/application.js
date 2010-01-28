// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function(){
  if (!jQuery.browser.mozilla) jQuery('#firefox_container').show();

  jQuery("#container input[name=reset]").click(function(){
    jQuery("#container form :input[type=text], #container form textarea").val("");
  });
});

function changeLocale(locale){
  if (gocool_locale == locale) return;
  
  var localeParam = "locale=" + locale;
  
  var queryString = location.search;
  if (queryString.match(/locale=/)) {
    queryString = queryString.replace(/locale=[a-z_]+/, localeParam);
  } else if (queryString.match(/\s*/)){
    queryString = "?" + localeParam;
  } else {
    queryString = queryString.replace('?', '?' + localeParam + '&');
  }
  
  window.location = location.pathname + queryString;
}

function showError(fieldId, errorMsg) {
  //validanguage.el[fieldId].showError(errorMsg);
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
