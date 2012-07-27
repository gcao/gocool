var jsGameViewer = function() {
	return {
    name: "jsgameviewer",
    version: "1.0a",
    length: 0,

    WEIQI: 0,
    DAOQI: 1,

    EN_US: "en_us",
    ZH_CN: "zh_cn",
    LOCALES: ["en_us", "zh_cn"],

    CONFIG: {
      baseDir: "/jsgameviewer/",
      viewDir: "/jsgameviewer/view/",
      locale: jsgvTranslations.locale,
      gameType: 0,
      boardSize: 19,
      playerInterval: 5,
      observerInterval: 15,
      container: null
    },

    debug: function(message){
      if (typeof(console) != "undefined") {
        console.log(message);
      }
    },

    getGameId: function(i){
      if (i == undefined){
        this.length ++;
        for(i=1; this["GV"+i]!=null; i++)
          ;
      }
      return "GV"+i;
    },

    createClass: function() {
      return function() {
        this.initialize.apply(this, arguments);
      }
    },

    clone: function(myObj){
      if(typeof(myObj) != 'object') return myObj;
      if(myObj == null) return myObj;

      var myNewObj = new Object();

      for(var i in myObj)
        myNewObj[i] = this.clone(myObj[i]);

      return myNewObj;
    },

    // return true if obj is String and not empty
    notNull: function(obj){
      return obj != undefined && obj != null && jq4gv.trim(obj).length > 0;
    },

    getId: function(x, y){
      return x+"-"+y;
    },

    showAjaxError: function(textStatus, errorThrown) {
      var mesg = jsgvTranslations["error_thrown"] + "\n";
      if (textStatus != undefined) mesg += textStatus + " ";
      if (errorThrown != undefined) mesg += errorThrown;
      alert(mesg.substr(0, 1000));
    }
	};
}();
var jsgv = jsGameViewer;
