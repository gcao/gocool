jsGameViewer.GameController = jsGameViewer.createClass();
jq4gv.extend(jsGameViewer.GameController.prototype, {
  initialize: function(config){
    this.id = jsGameViewer.getGameId();
    this.jqId = "#" + this.id;
    jsGameViewer[this.id] = this;

    this.config = jsGameViewer.clone(jsGameViewer.CONFIG);
    if (config != null)
      jq4gv.extend(this.config, config);

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

  changeLocale: function(new_locale){
    if (this.config.locale == new_locale)
      return this;
    if (!jsGameViewer.LOCALES.indexOf(new_locale) < 0){
      alert("jsGameViewer WARNING: Invalid locale '" + new_locale + "'");
      return this;
    }
    this.config.locale = new_locale;
    window.jsgvTranslations = window["jsgv_" + new_locale];
    jsGameViewer.WEIQI_TEMPLATE = null;
    jsGameViewer.DAOQI_TEMPLATE = null;
    this.reset();
    this.show();
    if (this.gameState){
      this.gameState.backAll();
      this.initGame();
    }
    return this;
  },

  destroy: function(){
    this.destroyView();
    delete jsGameViewer[this.id];
    jsGameViewer.length--;
  },

  reset: function(){
    this._initialized = false;

    if (this.config.container != null) {
      var container = jq4gv("#" + this.config.container);
      if (container.get(0).nodeName == 'DIV') {
        container.empty().append(this.getPlaceHolder());
      } else {
        if (jq4gv(this.jqId).get(0)) {
          jq4gv(this.jqId).replaceWith(this.getPlaceHolder());
        } else {
          container.after(this.getPlaceHolder());
        }
      }
    } else {
      if (jq4gv(this.jqId).get(0) != null)
        jq4gv(this.jqId).replaceWith(this.getPlaceHolder());
      else
        document.write(this.getPlaceHolder());
    }
    return this;
  },

  show: function(){
    if (!this.initialized())
      this.init();
    jq4gv(this.jqId).show();
    return this;
  },

  hide: function(){
    jq4gv(this.jqId).hide();
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
    if (this.config.gameType != jsGameViewer.DAOQI && this.game.type == jsGameViewer.DAOQI){
      this.setGameType(jsGameViewer.DAOQI);
    }
    return this;
  },

  load: function(url, n){
    var h = jsGameViewer.model.GameHistory[url];
    if (h){
      jsGameViewer.model.GameHistory.save(h);
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
    var _this = this;
    jq4gv.ajax({
      url:url,
      success:function(response){
        try {
          // if game data haven't changed, don't reload the game
          if (_this.game && _this.game.dataSize && _this.game.dataSize == response.length){
            return;
          }
          _this.game = new jsGameViewer.SGFParser(_this.config.gameType).parse(response);
          _this.game.dataSize = response.length;
          _this.setGameTypeIf(_this.game.type).show();
          _this.game.url = url;
          _this.gameState = new jsGameViewer.model.GameState(_this.game);
          jsGameViewer.model.GameHistory.save(_this.gameState);
          _this.initGame();
          if (n == undefined)
            _this.forwardAll();
          else
            _this.forwardN(n);
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

  loadSgf: function(sgf, n){
    try {
      sgf = jq4gv.trim(sgf);
      this.show();
      this.game = new jsGameViewer.SGFParser(this.config.gameType).parse(sgf);
      this.game.dataSize = sgf.length;
      this.setGameTypeIf(this.game.type);
      this.gameState = new jsGameViewer.model.GameState(this.game);
      this.initGame();
      if (n == undefined)
        this.forwardAll();
      else
        this.forwardN(n);
      return this;
    } catch(e) {
      throw "GameController.loadSgf('" + sgf + "'): " + e;
    }
  },

  loadInline: function(divId, n){
    try {
      if (jq4gv("#"+divId).length == 0){
        return this;
      }
      loadSgf(jq4gv("#"+divId).text(), n);
      return this;
    } catch(e) {
      throw "GameController.loadInline('" + divId + "'): " + e;
    }
  },

  refresh: function(force){
    var url = this.game.url;
    var _this = this;
    jq4gv.ajax({
      url:url,
      //ifModified: true,
      success:function(response){
        try {
          response = jq4gv.trim(response);
          jsgv.debug('refresh 1');
          // if game data haven't changed, don't reload the game
          if (!force && _this.game && _this.game.dataSize && _this.game.dataSize == response.length){
            return;
          }
          jsgv.debug('refresh 2');
          _this.game = new jsGameViewer.SGFParser(_this.config.gameType).parse(response);
          _this.game.dataSize = response.length;
          _this.setGameTypeIf(_this.game.type).show();
          _this.game.url = url;
          _this.gameState = new jsGameViewer.model.GameState(_this.game);
          jsGameViewer.model.GameHistory.save(_this.gameState);
          _this.initGame();
          _this.forwardAll();
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
    var url = this.config.baseDir + "/php/game_window.php?";
    var title = "jsgameviewer", width = 722, height = 452;
    if (this.config.gameType == jsGameViewer.DAOQI) {
      url += "type=DAOQI&";
      width = 798;
      height = 528;
    }
    if (this.game && this.game.url)
      url += "url=" + encodeURIComponent(this.game.url);
    var win = window.open(url, title, "width=" + width + "px,height=" + height + "px,status=yes,location=no,resizable=yes");
  },

  getPlaceHolder: function(){
    return "<div id='" + this.id + "' style='display:none'>&nbsp;</div>";
  }
});

// Added for backward compatibility
var GameController = jsGameViewer.GameController;
