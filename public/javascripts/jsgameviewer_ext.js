jQuery.extend(jsGameViewer.CONFIG, {
  gocoolUrlPrefix: "/app/"
});

jQuery.extend(jsGameViewer.GameController.prototype, {
  loadGocoolGame: function(id, n){
    this.gocoolId = id;
    var conf = this.config;
    return this.load(conf.gocoolUrlPrefix + "games/" + id + ".sgf", n);
  },

  createGocoolPlayer: function(){
    this.setPlayer(new GocoolPlayer(this));
    return this;
  }
});

var GocoolPlayer = jsGameViewer.createClass();
jQuery.extend(GocoolPlayer.prototype, {
  initialize: function(gameController){
    this.gameController = gameController;
  },

  isPlayer: function(){
    return true;
  },

  isMyTurn: function(){
    return true;
  },

  sendMove: function(){
    var c = this.gameController;
    var node = c.gameState.currentNode;
    var moveNumber = node.moveNumber;
    var x = node.x, y = node.y;
    var url = c.config.gocoolUrlPrefix + "games/" + c.gocoolId + "/play";
    url += "?x=" + x;
    url += "&y=" + y;
    if (node.parent && node.parent.name) url += "&parent_move_id=" + node.parent.name;

    // Important: this must be an async request to allow next moves
    jQuery.ajax({url: url,
      //async: false,
      success:function(response){
        if (response.charAt(0) == '0'){ // success
          var origUrl = c.game.url;
          var xys = c.gameState.getXYs();
          c.loadSgf(response.substr(2), 0);
          c.game.url = origUrl;
          c.goToXYs(xys);
          c.forwardAll();
          c.startUpdater(true);
        } else { // failure
          jsgv.showAjaxError("", response);
          c.remove();
        }
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        jsgv.showAjaxError(textStatus, errorThrown);
        c.remove();
      }
    });
    return true;
  },

  resign: function(){
    var c = this.gameController;
    var url = c.config.gocoolUrlPrefix + "games/" + c.gocoolId + "/resign";
    jQuery.ajax({url: url,
      success:function(response){
        if (response.charAt(0) == '0'){ // success
          // TODO: move to next game
          c.refresh();
        } else { // failure
          jsgv.showAjaxError("", response);
        }
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        jsgv.showAjaxError(textStatus, errorThrown);
      }
    });
    return true;
  }
});
