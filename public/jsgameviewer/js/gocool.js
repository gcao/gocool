//jq4gv.extend(jsGameViewer.CONFIG, {
//  gocoolUrlPrefix: "/app/"
//});
//
//jq4gv.extend(jsGameViewer.GameController.prototype, {
//  loadGocoolGame: function(id, n){
//    this.gocoolId = id;
//    var conf = this.config;
//    return this.load(conf.gocoolUrlPrefix + "games/" + id + ".sgf", n);
//  },
//
//  createGocoolPlayer: function(){
//    this.setPlayer(new GocoolPlayer(this));
//    return this;
//  }
//});
//
//var GocoolPlayer = jsGameViewer.createClass();
//jq4gv.extend(GocoolPlayer.prototype, {
//  initialize: function(gameController){
//    this.gameController = gameController;
//  },
//
//  isPlayer: function(){
//    return true;
//  },
//
//  isMyTurn: function(){
//    return true;
//  },
//
//  sendMove: function(){
//    var c = this.gameController;
//    var node = c.gameState.currentNode;
//    var parentNode = node.parent;
//    if (node.temp && (!parentNode || !parentNode.temp)){
//      // node contains the first try move.
//    } else {
//      //alert("This is not the first TRY move.");
//      alert(jsgvTranslations["not_first_move"]);
//      return false;
//    }
//    var moveNumber = node.moveNumber;
//    var x = node.x, y = node.y;
//    var url = c.config.gocoolUrlPrefix + "games/" + c.gocoolId + "/play";
//    url += "?move=" + moveNumber;
//    url += "&x=" + x;
//    url += "&y=" + y;
//    jq4gv.ajax({url: url,
//      success:function(response){
//        if (response.charAt(0) == '0'){ // success
//          // TODO: move to next game
//          c.refresh();
//        } else { // failure
//          alert(jsgvTranslations["error_thrown"] + "\n" + response);
//          c.remove();
//        }
//      },
//      error: function(XMLHttpRequest, textStatus, errorThrown){
//        jsgv.showAjaxError(textStatus, errorThrown);
//        c.remove();
//      }
//    });
//    return true;
//  },
//
//  resign: function(){
//    var c = this.gameController;
//    var url = c.config.gocoolUrlPrefix + "games/" + c.gocoolId + "/resign";
//    jq4gv.ajax({url: url,
//      success:function(response){
//        if (response.charAt(0) == '0'){ // success
//          // TODO: move to next game
//          c.refresh();
//        } else { // failure
//          alert(jsgvTranslations["error_thrown"] + "\n" + response);
//        }
//      },
//      error: function(XMLHttpRequest, textStatus, errorThrown){
//        jsgv.showAjaxError(textStatus, errorThrown);
//      }
//    });
//    return true;
//  }
//});
