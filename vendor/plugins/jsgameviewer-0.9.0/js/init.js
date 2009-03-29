var jq = jQuery.noConflict();

var gv = {
  name: "jsgameviewer",
  version: "1.0a",
  length: 0,
  getId: function(i){
    if (i == undefined){
      gv.length ++;
      for(i=1;gv["GV"+i]!=null;i++)
        ;
    }
    return "GV"+i;
  }
};

var WEIQI = 0;
var DAOQI = 1;

var CONFIG = {
  baseDir: "/jsgameviewer/",
  viewDir: "/jsgameviewer/view/",
  gameType: WEIQI,
  boardSize: 19,
  playerInterval: 5,
  observerInterval: 15,
  container: null
};

var Class = {
  create: function() {
    return function() {
      this.initialize.apply(this, arguments);
    }
  }
}

Object.extend = function(destination, source) {
  for (var property in source) {
    destination[property] = source[property];
  }
  return destination;
}

function clone(myObj){
  if(typeof(myObj) != 'object') return myObj;
  if(myObj == null) return myObj;

  var myNewObj = new Object();

  for(var i in myObj)
    myNewObj[i] = clone(myObj[i]);

  return myNewObj;
}

// return true if obj is String and not empty
function notNull(obj){
  return obj != undefined && obj != null && jq.trim(obj).length > 0;
}

function getId(x, y){
  return x+"-"+y;
}

var GameController = Class.create();