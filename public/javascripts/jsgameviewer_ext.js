jQuery.extend(jsGameViewer.GameController.prototype, {
  setPlayer: function(player){
    this.player = player;
    return this;
  },

  // This is required to keep the forum session alive when integrating with a forum like Discuz!
  saveSession: function(url, interval){
    if (!this.sessionSaver){
      this.sessionSaver = setInterval(function(){
        jQuery.ajax({url: url});
      }, interval*1000);
    }
    return this;
  },

  setUsernameElemId: function(elemId){
    this.usernameElemId = elemId;
    return this;
  },

  setUsername: function(username){
    this.username = username;
    return this;
  },

  getUsername: function(){
    if (this.username){
      return this.username;
    } else if (this.usernameElemId){
      return jQuery.trim(jQuery('#' + this.usernameElemId).text());
    } else {
      return null;
    }
  },

  isPlayer: function(){
    if (this.player && this.player.isPlayer){
      return this.player.isPlayer();
    } else {
      return false;
    }
  },

  isMyTurn: function(){
    if (this.player && this.player.isMyTurn){
      return this.player.isMyTurn();
    } else {
      return false;
    }
  },

  sendMove: function(){
    if (this.player && this.player.sendMove){
      return this.player.sendMove();
    } else {
      return false;
    }
  },

  resign: function(){
    if (this.player && this.player.resign){
      if (confirm(jsgvTranslations["confirm_resign"]))
        this.player.resign();
    } else {
      return false;
    }
  },

  origPlay: jsGameViewer.GameController.prototype.play,

  play: function(x, y){
    if (this.origPlay(x, y) && this.player && this.player.sendMove){
      return this.player.sendMove();
    }
  }
});

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
    var parentNode = node.parent;
    if (node.temp && (!parentNode || !parentNode.temp)){
      // node contains the first try move.
    } else {
      //alert("This is not the first TRY move.");
      alert(jsgvTranslations["not_first_move"]);
      return false;
    }
    var moveNumber = node.moveNumber;
    var x = node.x, y = node.y;
    var url = c.config.gocoolUrlPrefix + "games/" + c.gocoolId + "/play";
    url += "?move=" + moveNumber;
    url += "&x=" + x;
    url += "&y=" + y;
    jQuery.ajax({url: url,
      success:function(response){
        if (response.charAt(0) == '0'){ // success
          // TODO: move to next game
          c.refresh();
        } else { // failure
          alert(jsgvTranslations["error_thrown"] + "\n" + response);
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
          alert(jsgvTranslations["error_thrown"] + "\n" + response);
        }
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        jsgv.showAjaxError(textStatus, errorThrown);
      }
    });
    return true;
  }
});
