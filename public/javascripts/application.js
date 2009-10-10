// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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