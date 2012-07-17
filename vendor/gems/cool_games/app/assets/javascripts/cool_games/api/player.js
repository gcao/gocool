jQuery.extend(jsGameViewer.CONFIG, {
  gocoolUrlPrefix: "/api/"
});

jQuery.extend(jsGameViewer.GameController.prototype, {
  loadGocoolGame: function(id, n){
    this.gocoolId = id;
    var url = this.config.gocoolUrlPrefix + "games/" + id + ".sgf"
    url = addAuthToUrl(url);
    return this.load(url, n);
  },

  createGocoolPlayer: function(){
    this.setPlayer(new GocoolPlayer(this));
    return this;
  },

  play: function(x, y){
    if (gameState == 'counting_preparation'){
      var url = this.config.gocoolUrlPrefix + "games/" + this.gocoolId + "/mark_dead?x=" + x + "&y=" + y;
      url = addAuthToUrl(url);
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
    url = addAuthToUrl(url)

    var _this = this;
    // Important: this must be an async request to allow next moves
    jQuery.ajax({
      url: url,
      async: false,
      dataType: 'json',
      success:function(response){
        if (response.status == 'success'){
          var origUrl = c.game.url;
          var x0 = c.config.x0 - c.config.vbw;
          var y0 = c.config.y0 - c.config.vbw;
          var xys = c.gameState.getXYs();
          c.loadSgf(response.body);
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
        } else {
          jsgv.showAjaxError("", response.body);
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
    url = addAuthToUrl(url)
    var _this = this;
    jQuery.ajax({
      url: url,
      async: false,
      dataType: 'json',
      success:function(response){
        if (response.status == 'success'){
          c.refresh();
        } else {
          jsgv.showAjaxError("", response.body);
        }
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        jsgv.showAjaxError(textStatus, errorThrown);
      }
    });
    return true;
  }
});

