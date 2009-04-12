Object.extend(GameController.prototype, {
  initialize: function(config){
    this.id = gv.getId();
    gv[this.id] = this;
    this.config = clone(CONFIG);
    if (config != null)
      Object.extend(this.config,config);
    this.reset();
  },
  
  init: function(){
    this.initView();
    this._initialized = true;
    return this;
  },
  
  initialized: function(){
    return this._inialized == true;
  },

  destroy: function(){
    this.destroyView();
    delete gv[this.id];
    gv.length--;
  },
  
  reset: function(){
    this._initialized = false;
    if (this.config.container != null) 
      jQuery("#" + this.config.container).empty().append(this.getPlaceHolder());
    else {
      if (document.getElementById(this.id) != null)
        jQuery("#"+this.id).replaceWith(this.getPlaceHolder());
      else
        document.write(this.getPlaceHolder());
    }
    return this;
  },

  show: function(){
    if (!this.initialized())
      this.init();
    jQuery("#" + this.id).show();
    return this;
  },
  
  hide: function(){
    jQuery("#" + this.id).hide();
    return this;
  },

  setGameType: function(gameType){
    if (this.config.gameType != gameType){
      this.config.gameType = gameType;
      this.reset();
    }
    return this;
  },
  
  // set game type if DAOQI
  setGameTypeIf: function(gameType){
    if (this.config.gameType != DAOQI && this.game.type == DAOQI){
      this.setGameType(DAOQI);
    }
    return this;
  },

  load: function(url, n){
    var h = GameHistory[url];
    if (h != undefined && h != null){
      GameHistory.save(h);
      this.game = h.game;
      this.setGameTypeIf(this.game.type).show();
      this.gameState = h;
      this.gameState.backAll();
      this.initGame();
      if (n == undefined)
        this.forwardAll();
      else
        this.forwardN(n);
      return this;
    }
    var c = this;
    jQuery.ajax({url:url,
      success:function(response){
        try {
          // if game data haven't changed, don't reload the game
          if (c.game && c.game.dataSize && c.game.dataSize == response.length){
            return;
          }
          c.game = new SGFParser(c.config.gameType).parse(response);
          c.game.dataSize = response.length;
          c.setGameTypeIf(c.game.type).show();
          c.game.url = url;
          c.gameState = new GameState(c.game);
          GameHistory.save(c.gameState);
          c.initGame();
          if (n == undefined)
            c.forwardAll();
          else
            c.forwardN(n);
        } catch(e) {
          throw "GameController.load('" + url + "')->success: " + e;
        }
      },
      failure:function(){
        throw "GameController.load('" + url + "')->failure:";
      }
    });
    return this;
  },
  
  loadInline: function(divId, n){
    try {
      if (jQuery("#"+divId).length == 0){
        return this;
      }
      var s = jQuery.trim(jQuery("#"+divId).text());
      // if game data haven't changed, don't reload the game
      if (this.game && this.game.dataSize && this.game.dataSize == s.length){
        return this;
      }
      this.game = new SGFParser(this.config.gameType).parse();
      this.game.dataSize = s.length;
      this.setGameTypeIf(this.game.type);
      this.gameState = new GameState(this.game);
      this.initGame();
      if (n == undefined)
        this.forwardAll();
      else
        this.forwardN(n);
      return this;
    } catch(e) {
      throw "GameController.loadInline('" + divId + "'): " + e;
    }
  },
  
  refresh: function(force){
    var url = this.game.url;
    var c = this;
    jQuery.ajax({url:url,
      ifModified: true,
      success:function(response){
        try {
          // if game data haven't changed, don't reload the game
          if (!force && c.game && c.game.dataSize && c.game.dataSize == response.length){
            return;
          }
          c.game = new SGFParser(c.config.gameType).parse(response);
          c.game.dataSize = response.length;
          c.setGameTypeIf(c.game.type).show();
          c.game.url = url;
          c.gameState = new GameState(c.game);
          GameHistory.save(c.gameState);
          c.initGame();
          c.forwardAll();
        } catch(e) {
          throw "GameController.refresh('" + url + "')->success: " + e;
        }
      },
      failure:function(){
        throw "GameController.refresh('" + url + "')->failure:";
      }
    });
  },
  
  openInWindow: function(){
    var url = this.config.baseDir + "gamewindow.php?";
    var title = "jsgameviewer", width = 722, height = 452;
    if (this.config.gameType == DAOQI) {
      url += "type=DAOQI&";
      width = 798;
      height = 528;
    }
    if (this.game && this.game.url)
      url += "url=" + encodeURIComponent(this.game.url);
    var win = window.open(url, title, "width=" + width + "px,height=" + height + "px,status=yes,location=no,resizable=yes");
  },
  
  setPlayer: function(player){
    this.player = player;
    return this;
  },
  
  setPlayerInterval: function(interval){
    this.config.playerInterval = interval;
    return this;
  },
  
  setObserverInterval: function(interval){
    this.config.observerInterval = interval;
    return this;
  },

  startUpdater: function(){
    this.stopUpdater();
    if (this.game && !this.game.isFinished())
      return this;
    var c = this;
    var updaterFunc = function(){
      if (!c.game)
        return;
      if (c.game.isFinished()){
        c.stopUpdater();
        return;
      }
      if (c.isMyTurn())
        return;
      c.refresh();
    };
    if (this.player){
      this.playerUpdater = setInterval(updaterFunc, this.config.playerInterval*1000);
    }
    this.observerUpdater = setInterval(updaterFunc, this.config.observerInterval*1000);
    return this;
  },
  
  stopUpdater: function(){
    if (this.playerUpdater){
      clearInterval(this.playerUpdater);
      delete this.playerUpdater;
    }
    if (this.observerUpdater){
      clearInterval(this.observerUpdater);
      delete this.observerUpdater;
    }
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
      //alert("This is not a DGS game. \nCurrently the program only supports to play on DGS.");
      alert("这不是DGS对局。本程序目前只支持在DGS上下棋。");
      return false;
    }
  },
  
  resign: function(){
    if (this.player && this.player.resign){
      // var answer = confirm("Are you sure that you would like to resign?");
      var answer = confirm("你确实要认输吗？");
      if (answer)
        this.player.resign();
    } else {
      //alert("This is not a DGS game. Currently the program only supports to play on DGS.");
      alert("这不是DGS对局。本程序目前只支持在DGS上下棋。");
      return false;
    }
  },
  
  getPlaceHolder: function(){
    return "<div id='" + this.id + "' style='display:none'>&nbsp;</div>";
  }
});

// methods to keep backward compatibility
GameController.prototype.loadGame = GameController.prototype.load;