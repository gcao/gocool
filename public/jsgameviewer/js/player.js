jq4gv.extend(jsGameViewer.GameController.prototype, {
  setPlayer: function(player){
    this.player = player;
    return this;
  },

  // This is required to keep the forum session alive when integrating with a forum like Discuz!
  saveSession: function(url, interval){
    if (!this.sessionSaver){
      this.sessionSaver = setInterval(function(){
        jq4gv.ajax({url: url});
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
      return jq4gv.trim(jq4gv('#' + this.usernameElemId).text());
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
