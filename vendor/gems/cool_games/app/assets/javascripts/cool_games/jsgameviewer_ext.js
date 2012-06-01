jsgv.OP_SUCCESS    = "0";
jsgv.OP_FAILURE    = "1";
jsgv.OP_JAVASCRIPT = "2";

jQuery.extend(jsGameViewer.CONFIG, {
  //gocoolUrlPrefix: "/app/"
  gocoolUrlPrefix: "/"
});

jQuery.extend(jsGameViewer.GameController.prototype, {
  loadGocoolGame: function(id, n){
    this.gocoolId = id;
    return this.load(this.config.gocoolUrlPrefix + "games/" + id + ".sgf", n);
  },

  createGocoolPlayer: function(){
    this.setPlayer(new GocoolPlayer(this));
    return this;
  },

  play: function(x, y){
    if (gameState == 'counting_preparation'){
      var url = this.config.gocoolUrlPrefix + "games/" + this.gocoolId + "/mark_dead?x=" + x + "&y=" + y;
      jQuery.ajax({
        url: url,
        success: function(){
          location.reload(true);
        }
      });
      return this;
    }
    if (this.origPlay(x, y) && this.player && this.player.sendMove){
      return this.player.sendMove();
    }
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

  parseResponse: function(response){
    var status = jsgv.OP_FAILURE;
    var message = response;
    if (response && response[1] == ":"){
      status = response[0];
      message = response;
    }
    return { status: status, message: message };
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

    var _this = this;
    // Important: this must be an async request to allow next moves
    jQuery.ajax({url: url,
      async: false,
      success:function(response){
        var parsed = _this.parseResponse(response);
        if (parsed.status == jsgv.OP_SUCCESS){
          var origUrl = c.game.url;
          var x0 = c.config.x0 - c.config.vbw;
          var y0 = c.config.y0 - c.config.vbw;
          var xys = c.gameState.getXYs();
          c.loadSgf(parsed.message);
          c.game.url = origUrl;
          if (c.game.type == jsGameViewer.DAOQI) {
            // Restore board position
            c.config.x0 = c.config.y0 = c.config.vbw;
            c.moveBoard(x0, y0);
          }
          c.goToXYs(xys);

          // Forward to end of the game if I am not looking at a gusss move
          if (!c.gameState.currentNode.hasComment()) c.forwardAll();

          //c.startUpdater(true); // TODO: auto refresh game
        } else if (parsed.status == jsgv.OP_JAVASCRIPT){
          eval(parsed.message);
        } else {
          jsgv.showAjaxError("", parsed.message);
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
    var _this = this;
    jQuery.ajax({url: url,
      success:function(response){
        var parsed = _this.parseResponse(response);
        if (parsed.status == jsgv.OP_SUCCESS){
          c.refresh();
        } else if (parsed.status == jsgv.OP_JAVASCRIPT){
          eval(parsed.message);
        } else {
          jsgv.showAjaxError("", parsed.message);
        }
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        jsgv.showAjaxError(textStatus, errorThrown);
      }
    });
    return true;
  }
});
