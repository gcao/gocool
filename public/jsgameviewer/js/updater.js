jq4gv.extend(jsGameViewer.GameController.prototype, {
  setPlayerInterval: function(interval){
    this.config.playerInterval = interval;
    return this;
  },

  setObserverInterval: function(interval){
    this.config.observerInterval = interval;
    return this;
  },

  startUpdater: function(force){
    this.stopUpdater();
    if (this.game && this.game.isFinished())
      return this;
    var _this = this;
    var updaterFunc = function(){
      if (!_this.game)
        return;
      if (_this.game.isFinished()){
        _this.stopUpdater();
        return;
      }
      if (!force && _this.isMyTurn())
        return;
      _this.refresh();
    };
    var interval = this.config.observerInterval;
    if (this.player) interval = this.config.playerInterval;

    this.updater = setInterval(updaterFunc, interval*1000);
    return this;
  },

  stopUpdater: function(){
    if (this.updater){
      clearInterval(this.updater);
      delete this.updater;
    }
    return this;
  }
});
