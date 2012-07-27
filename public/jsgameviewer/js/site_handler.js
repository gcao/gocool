// Directly access location.protocol, location.host, location.pathname
function localhostHandler(){
  if (location.host == 'localhost') {
    if (location.pathname == '/jsgameviewer/examples/load_sgf.html') {
      jsgvLoader.loadSgf();
      return true;
    }
  }
}

jsgvLoader.addSiteHandler(localhostHandler);