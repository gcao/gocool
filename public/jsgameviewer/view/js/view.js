// Default view configuration
Object.extend(CONFIG, {
  gridSize:21,
  fastMode:10,
  showMoveNumber:false,
  activeBackground: "#EECD7A",
  inactiveBackground: "#CCAB69",
  boardColor:"#EECD7A",
  gridSizeWQ:21,
  gridSizeDQ:19,
  boardColorDQ:"#CCAB69",
  vbw:3,
  boardSizeDQ:25,
  rightPaneHeight:446,
  rightPaneHeightDQ:522
});

var LABELS = ['A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T'];
var BRANCHES = ['A','B','C','D','E','F','G','H','I','J'];
var WEIQI_TEMPLATE = null;
var DAOQI_TEMPLATE = null;

Object.extend(GameController.prototype, {
  destroyView: function(){
    jQuery("#"+this.id).remove();
  },

  /* initialize view
   */
  initView: function(){
    var c = this;
    if (c.initialized())
      return c;
    var conf = c.config;
    conf.x0 = conf.vbw;
    conf.y0 = conf.vbw;
    var s = "";
    if (conf.gameType == DAOQI){
      conf.gridSize = conf.gridSizeDQ;
      if (DAOQI_TEMPLATE == null){
        jQuery.ajax({
          async: false,
          dataType: "application/xml",
          url: CONFIG.viewDir+"templates/daoqi.html",
          success: function(response){
            DAOQI_TEMPLATE = response;
          }
        });
      }
      s = DAOQI_TEMPLATE;
      c.rightPaneHeight = conf.rightPaneHeightDQ;
    } else {
      conf.gridSize = conf.gridSizeWQ;
      if (WEIQI_TEMPLATE == null){
        jQuery.ajax({
          async: false,
          dataType: "application/xml",
          url: CONFIG.viewDir+"templates/weiqi.html",
          success: function(response){
            WEIQI_TEMPLATE = response;
          }
        });
      }
      s = WEIQI_TEMPLATE;
      c.rightPaneHeight = conf.rightPaneHeight;
    }
    if (c.id != 'GV1')
      s = s.replace(/GV1/g, c.id);
    if (conf.container == null) {
      jQuery("#"+c.id).replaceWith(s);
    } else {
      jQuery("#"+conf.container).empty().append(s);
    }
    fdSliderController.construct();
    jQuery("#"+c.id+"_boardFascade").mousemove(function(e){
      c.registerKeyListener();
      var arr = c.eventToXY(e);
      jQuery("#"+c.id+"_pointLabel").empty().append(c.xyToLabel(arr[0],arr[1]));
    }).mouseout(function(e){
      jQuery("#"+c.id+"_pointLabel").empty();
    }).mousedown(function(e){
      var arr = c.eventToXY(e);
      c.fromX = arr[0];
      c.fromY = arr[1];
      // console.log("fromX: " + c.fromX + ", fromY: " + c.fromY);
      if (e.ctrlKey && e.shiftKey){
        c.sendMove_(arr[0], arr[1]);
      } else if (e.ctrlKey || c.config.gameType == WEIQI){
        c.play(arr[0],arr[1]);
      } else if (c.config.gameType == DAOQI){
        this.style.cursor = 'move';
      }
    }).mouseup(function(e){
      this.style.cursor = 'auto';
      var arr = c.eventToXY(e);
      var toX = arr[0], toY = arr[1];
      // console.log("toX: " + toX + ", toY: " + toY);
      if (c.fromX == undefined || c.fromX == NaN || c.fromY == undefined || c.fromY == NaN)
        return;
      if (c.fromX != toX || c.fromY != toY) {
        c.moveBoard(toX-c.fromX, toY-c.fromY);
      }
    });
    c.setToggleNumberImg();
    jQuery("#"+c.id+"_goToInput").keydown(function(){
      if(e.keyCode==13){
        gvGoTo(id);
      }
    });
    c.addPrisonerHandlers();
    c.registerKeyListener();
    jQuery(document).ready(function(){tb_init("a.thickbox")});
    return c;
  },
  
  addPrisonerHandlers: function(){
    var c = this;
    jQuery("#" + this.id + "_moveOuter, #" + this.id + "_blackPrisonersOuter, #" + this.id + "_whitePrisonersOuter")
      .mouseout(function(){
        jQuery("#"+c.id+"_prisoners").empty();        
      });
    jQuery("#" + this.id + "_blackPrisonersOuter").mouseover(function(){
      jQuery("#"+c.id+"_prisoners").empty();
      if (c.gameState.blackPrisoners > 0){
        jQuery.each(c.gameState.blackPrisonerPoints, function(i,item){
          c.showPrisoner(item);
        });
      }
    });
    jQuery("#" + this.id + "_whitePrisonersOuter").mouseover(function(){
      jQuery("#"+c.id+"_prisoners").empty();
      if (c.gameState.whitePrisoners > 0){
        jQuery.each(c.gameState.whitePrisonerPoints, function(i,item){
          c.showPrisoner(item);
        });
      }
    });
    jQuery("#" + this.id + "_moveOuter").mouseover(function(){
      jQuery("#"+c.id+"_prisoners").empty();
      if (c.gameState.currentNode.blackPrisoners > 0){
        jQuery.each(c.gameState.currentNode.blackPrisonerPoints, function(i,item){
          c.showPrisoner(item);
        });
      }
      if (c.gameState.currentNode.whitePrisoners > 0){
        jQuery.each(c.gameState.currentNode.whitePrisonerPoints, function(i,item){
          c.showPrisoner(item);
        });
      }
    });
  },
  
  showPrisoner: function(item){
    var c = this;
    var conf = c.config;
    var x = item[0], y = item[1], color = item[2];
    var area = c.xyToArea(x,y);
    var left = area[0], top = area[1], width = area[2], height = area[3];
    if (conf.gameType == DAOQI) {
      var cssClass = color == STONE_BLACK? "gvsprite-19-markblack" : "gvsprite-19-markwhite";
      c.mapToPoints(x,y,function(x1,y1){
        var area = c.xyToArea(x1,y1);
        var left = area[0], top = area[1], width = area[2], height = area[3];
        var s = "<div class='"+cssClass+"' style='position:absolute;left:"+left+"px;top:"+top+"px;";
        if (c.gameState.board[x][y] == STONE_NONE){
          if (c.isInCentralArea(x1,y1)){
            s += "background-color:"+conf.boardColorDQ+";";
          } else {
            s += "background-color:"+conf.boardColor+";";
          }
        }
        s += "'></div>";
        jQuery("#"+c.id+"_prisoners").append(s);
      });
    } else {
      var cssClass = color == STONE_BLACK? "gvsprite-21-markblack" : "gvsprite-21-markwhite";
      var s = "<div class='"+cssClass+"' style='position:absolute;left:"+left+"px;top:"+top+"px;";
      if (c.gameState.board[x][y] == STONE_NONE){
        s += "background-color:"+conf.boardColor+";";
      }
      s += "'></div>";
      jQuery("#"+c.id+"_prisoners").append(s);
    }
  },

  removeKeyListener: function(){
    jQuery("#"+this.id+"_bannerbg").css("background-color",this.config.inactiveBackground);
  },
  
  registerKeyListener: function(){
    var c = this;
    for(var i=1; i<=gv.length; i++){
      gv[gv.getId(i)].removeKeyListener();
    }
    jQuery("#"+this.id+"_bannerbg").css("background-color",c.config.activeBackground);
    document.onkeydown = function(e){
      var keyCode;
      if (window.event)
        keyCode = window.event.keyCode;
      else if (e)
        keyCode = e.which;
      else 
        return;
        
      e = e || window.event;
      switch(keyCode){
        case 37: // left
          if (e.ctrlKey){
            if (e.altKey)
              c.backAll();
            else
              c.backN(c.config.fastMode)
          } else {
            if (e.altKey && e.shiftKey)
              c.backToComment();
            else
              c.back();
          }
          return;
        case 39: // right
          if (e.ctrlKey){
            if (e.altKey)
              c.forwardAll();
            else
              c.forwardN(c.config.fastMode);
          } else {
            if (e.altKey && e.shiftKey)
              c.forwardToComment();
            else
              c.forward();
          }
          return;
        case 46: // delete
          c.remove();
          return;
      }
      
      if (e.altKey && e.shiftKey){
        switch (keyCode) {
          case 71: // g
            setTimeout("gv."+c.id+".goToPopup()",100);
            break;
          case 77: // m
            c.toggleNumber();
            break;
          case 82: // r
            c.refresh();
            break;
          default: // a: 65, z: 90
            if (keyCode >= 65 && keyCode <= 90){
              c.goToBranch(keyCode - 65);
            }
        }
      }
    };
    return c;
  },

  /* reset view to beginning of a game
   */
  initGame: function(){
    return this.removeAllStones()
      .setGameInfo()
      .setGameState()
      .addRemoveStones(this.gameState.currentNode.points);
  },
  
  setGameInfo: function(){
    var c = this;
    // show/hide resign button
    if (c.isMyTurn()){
      jQuery("#" + c.id + "_resign").show();
    } else {
      jQuery("#" + c.id + "_resign").hide();
    }
    var infoNode = jQuery("#" + c.id + "_info").empty();
    var game = c.game;
    if (game == undefined || game == null)
      return c;
    if (notNull(game.name)){
      infoNode.append("<div align='center' style='font-weight:bold'>"+jQuery.trim(game.name)+"</div>");
    }
    if (notNull(game.date)){
      infoNode.append("<div>&#26102;&#38388;&#65306;"+jQuery.trim(game.date)+"</div>");
    }
    if (notNull(game.place)){
      infoNode.append("<div>&#22320;&#28857;&#65306;"+jQuery.trim(game.place)+"</div>");
    }
    var playFirst = "&nbsp;&lt;-&nbsp;&#20808;&#34892;";
    // black player name + rank
    var blackRank = "";
    if (notNull(game.blackRank))
      blackRank = "&nbsp;("+game.blackRank+")";
    var blackPlayer = "<div>&#40657;&#26041;&#65306;<strong>"+jQuery.trim(game.blackName)+"</strong>"+blackRank;
    if (game.getFirstPlayer() == STONE_BLACK)
      blackPlayer += playFirst;
    blackPlayer += "</div>";
    infoNode.append(blackPlayer);   
    // white player name + rank
    var whiteRank = "";
    if (notNull(game.whiteRank))
      whiteRank = "&nbsp;("+game.whiteRank+")";
    var whitePlayer = "<div>&#30333;&#26041;&#65306;<strong>"+jQuery.trim(game.whiteName)+"</strong>"+whiteRank;
    if (game.getFirstPlayer() == STONE_WHITE)
      whitePlayer += playFirst;
    whitePlayer += "</div>";
    infoNode.append(whitePlayer);
    if (game.handicap > 0){
      infoNode.append("<div>&#35753;&#23376;&#65306;"+game.handicap+"</div>");
    } else {
      infoNode.append("<div>&#35268;&#21017;&#65306;"+jQuery.trim(game.rule)+"</div>");
      if (game.rule == "Chinese")
        infoNode.append("<div>&#36148;&#23376;&#65306;"+game.komi+"</div>");
      else
        infoNode.append("<div>&#36148;&#30446;&#65306;"+game.komi+"</div>");
    }
    infoNode.append("<div>&#25163;&#25968;&#65306;"+game.getMoves()+"</div>");
    infoNode.append("<div>&#32467;&#26524;&#65306;"+jQuery.trim(game.result)+"</div>");
    return c;
  },
  
  removeGameInfo: function(){
    jQuery("#" + this.id + "_info").empty();
    return this;
  },
  
  setGameState: function(){
    var c = this;
    var gameState = c.gameState;
    var node = gameState.currentNode;
    c.setNextPlayer(gameState.getNextPlayer());
    c.setMoveNumber(node.moveNumber);
    c.setPrisoners(gameState.blackPrisoners, gameState.whitePrisoners);
    if (node.type == NODE_MOVE)
      c.setMoveMark(node.x, node.y);
    else
      c.removeMoveMark();
    c.setMarks(node.marks);
    c.setBranches();
    c.setComment();
    return c;
  },
  
  moveBoard: function(xDiff,yDiff){
    var c = this;
    var conf = c.config;
    if (conf.gameType != DAOQI)
      return;
    var board = c.gameState.board;
    conf.x0 = board.normalize(conf.x0+xDiff);
    conf.y0 = board.normalize(conf.y0+yDiff);
    // remove stones
    c.removeAllStones();
    // remove branches
    c.removeBranches();
    // hide move mark
    c.removeMoveMark();
    // add stones
    var s = "";
    for(var i=0; i<board.size; i++){
      for(var j=0; j<board.size; j++){
        var color = board[i][j];
        if (color == STONE_BLACK || color == STONE_WHITE){
          var moveNumber = 0;
          if (c.config.showMoveNumber)
            moveNumber = c.gameState.getMoveNumber(i,j);
          c.mapToPoints(i,j,function(x,y){
            s += c.createStone(x,y,color,moveNumber);
          });
        }
      }
    }
    if (s.length > 0)
      jQuery("#"+c.id+"_boardPoints").append(s);
    // add branches
    c.setBranches();
    // show move mark
    var node = c.gameState.currentNode;
    if (node.type == NODE_MOVE)
      c.setMoveMark(node.x, node.y);
    else
      c.removeMoveMark();
    // move labels
    var vlabelStart = (conf.y0-conf.vbw)*conf.gridSize;
    jQuery("#"+c.id+"_vlabel").css("backgroundPosition", "0px "+vlabelStart+"px");
    var hlabelStart = (conf.x0-conf.vbw)*conf.gridSize;
    jQuery("#"+c.id+"_hlabel").css("backgroundPosition", hlabelStart+"px 0px");
    // move marks
    c.setMarks(node.marks);
    return c;
  },

  mapToPoints_: function(x,y){
    //console.log("GameView.mapToPoints(): "+x+","+y);
    var conf = this.config;
    var stones = new Array();
    var x1 = x+conf.x0, y1 = y+conf.y0;
    var xarr = [];
    if (x1>=0 && x1<conf.boardSizeDQ)
      xarr.push(x1);
    if (x1>=conf.boardSize)
      xarr.push(x1-conf.boardSize);
    if (x1<conf.boardSizeDQ-conf.boardSize)
      xarr.push(x1+conf.boardSize);

    var yarr = [];
    if (y1>=0 && y1<conf.boardSizeDQ)
      yarr.push(y1);
    if (y1>=conf.boardSize)
      yarr.push(y1-conf.boardSize);
    if (y1<conf.boardSizeDQ-conf.boardSize)
      yarr.push(y1+conf.boardSize);

    for(var i=0; i<xarr.length; i++)
      for(var j=0; j<yarr.length; j++){
        //console.log(xarr[i]+","+yarr[j]);
        stones.push([xarr[i],yarr[j]]);
      }
    return stones;
  },
  
  mapToPoints: function(x,y,func){
    var stones = this.mapToPoints_(x,y);
    for(var i=0; i<stones.length; i++){
      var stone = stones[i];
      func(stone[0],stone[1]);
    }
    return this;
  },
  
  getStoneId: function(x,y){
    return this.id+"_point_"+x+"-"+y;
  },
  
  createStone: function(x,y,color,moveNumber){
    var c = this;
    var styleClass = "";
    if (c.config.gameType == DAOQI){
      if (color == STONE_BLACK)
        styleClass = "gvsprite-19-black";
      else if (color == STONE_WHITE)
        styleClass = "gvsprite-19-white";
      else
        return null;
    } else {
      if (color == STONE_BLACK)
        styleClass = "gvsprite-21-black";
      else if (color == STONE_WHITE)
        styleClass = "gvsprite-21-white";
      else
        return null;
    }
    var s = "<div id='" + c.getStoneId(x,y) + "' class='" + styleClass + "' style='position:absolute;left:";
    a = c.xyToArea(x,y);
    s += a[0] + "px;top:" + a[1] + "px;'>";
    if (c.config.showMoveNumber && moveNumber > 0){     
      // http://www.jakpsatweb.cz/css/css-vertical-center-solution.html
      var colorS = "white";
      if (color == STONE_WHITE)
        colorS = "black";
      var fontSize = "medium";
      var left = 0;
      if (moveNumber >= 10 && moveNumber < 100){
        fontSize = "small";
      }else if (moveNumber >= 100){
        fontSize = "x-small";
        left = 1;
      }
      s += "<div style='display:table;width:"+a[2]+"px;height:"+a[3]+"px;#position:relative;overflow:hidden;'><div style='display:table-cell;vertical-align:middle;#position:absolute;#top:50%;'>"
        +"<div style='#position:relative;left:"+left+"px;width:100%;#top:-50%;text-align:center;color:"+colorS+";font-family:times;font-size:"+fontSize+";'>"+moveNumber+"</div></div></div>";
    } else {
      s += "&nbsp;";
    }
    s += "</div>";
    return s;
  },
  
  addStone: function(x,y,color){
    var c = this;
    var conf = c.config;
    var moveNumber = 0;
    if (conf.showMoveNumber){
      moveNumber = c.gameState.getMoveNumber(x,y);
    }
    if (conf.gameType == DAOQI){
      c.mapToPoints(x,y,function(x,y){
        var s = c.createStone(x,y,color,moveNumber);
        if (s != null){
          jQuery("#"+c.id+"_boardPoints").append(s);
        }
      });
    } else {
      var s = c.createStone(x,y,color,moveNumber);
      if (s != null){
        jQuery("#"+c.id+"_boardPoints").append(s);
      }
    }
    return c;
  },
  
  /*
   * iterate through points
   * remove all
   * add those whose deleteFlag is not set
   */
  addRemoveStones: function(points){
    var c = this;
    for(var i=0; i<points.length; i++){
      var point = points[i];
      c.removeStone(point.x,point.y);
      if (!point.deleteFlag){
        c.addStone(point.x, point.y, point.color);
      }
    }
    return c;
  },
  
  removeStone: function(x,y){
    var c = this;
    var conf = c.config;
    if (conf.gameType == DAOQI){
      this.mapToPoints(x,y,function(x,y){
        var stone = jQuery("#"+c.getStoneId(x,y));
        stone.remove();
      });
    } else {
      var stone = jQuery("#"+c.getStoneId(x,y));
      stone.remove();
    }
    return c;
  },
  
  /*
   * remove all stones on the board
   */
  removeAllStones: function(){
    jQuery("#"+this.id+"_boardPoints").children().remove();
    return this;
  },
  
  setNextPlayer: function(color){
    var s = "";
    if (color == STONE_BLACK)
      s += "&#40657;";
    else if (color == STONE_WHITE)
      s += "&#30333;";
    jQuery("#"+this.id+"_nextPlayer").empty().append(s);
    return this;
  },
  
  setMoveNumber: function(moveNumber){
    if (moveNumber == 0)
      moveNumber = "0";
    jQuery("#"+this.id+"_curMove").empty().append(moveNumber);
    return this;
  },
  
  setMoveMark: function(x,y){
    var c = this;
    var conf = c.config;
    if (conf.gameType == DAOQI){
      jQuery("#"+c.id+"_moveMarks").empty();
      c.mapToPoints(x,y,function(x,y){
        var area = c.xyToArea(x,y);
        jQuery("#"+c.id+"_moveMarks").append("<div class='gvsprite-19-markmove' style='position:absolute;left:"+
          area[0]+"px;top:"+area[1]+"px;width:"+area[2]+"px;height:"+area[3]+"px'>&nbsp;</div>");
      });
    } else {
      jQuery("#"+c.id+"_moveMark").css({position: "absolute", left:x*conf.gridSize, top:y*conf.gridSize, width:conf.gridSize, height:conf.gridSize});
    }
    return c;
  },
  
  removeMoveMark: function(){
    var c = this;
    if (c.config.gameType == DAOQI){
      jQuery("#"+c.id+"_moveMarks").empty();
    } else {
      jQuery("#"+c.id+"_moveMark").css({width:0, height:0});
    }
    return c;
  },
  
  setMarks: function(marks){
    var c = this;
    jQuery("#"+c.id+"_boardMarks").empty();
    if (marks == undefined || marks == null)
      return c;
    var conf = c.config;
    if (conf.gameType == DAOQI){
      for (var i=0; i<marks.length; i++){
        var mark = marks[i];
        var x = mark[0], y = mark[1];
        var color = c.gameState.board[x][y];
        var styleClass = "";
        switch(mark[2]){
          case MARK_CROSS:
            styleClass = "gvsprite-19-markcross";
            break;
          case MARK_TRIANGLE:
            styleClass = "gvsprite-19-marktriangle";
            break;
          case MARK_SQUARE:
            styleClass = "gvsprite-19-marksquare";
            break;
          case MARK_CIRCLE:
            styleClass = "gvsprite-19-markcircle";
            break;
          case MARK_TERR_BLACK:
            styleClass = "gvsprite-19-markblack";
            break;
          case MARK_TERR_WHITE:
            styleClass = "gvsprite-19-markwhite";
            break;
          case MARK_TEXT:
            c.mapToPoints(x,y,function(x,y){
              var area = c.xyToArea(x,y);
              var left = area[0], top = area[1], width = area[2], height = area[3];
              var s = "<div style='position:absolute;left:"+left+"px;top:"+top+"px;width:"+width+"px;height:"+height+"px;text-align:center;vertical-align:middle;color:red;font-family:Nina;font-weight:bolder;font-size:14px;";
              if (color == STONE_NONE){
                if (c.isInCentralArea(x,y)){
                  s += "background-color:"+conf.boardColorDQ+";";
                } else {
                  s += "background-color:"+conf.boardColor+";";
                }
              }
              s += "'>"+mark[3]+"</div>";
              jQuery("#"+c.id+"_boardMarks").append(s);
            });
            continue;
        }
        c.mapToPoints(x,y,function(x,y){
          var area = c.xyToArea(x,y);
          var left = area[0], top = area[1], width = area[2], height = area[3];
          var s = "<div class='"+styleClass+"' style='position:absolute;left:"+left+"px;top:"+top+"px;";
          if (color == STONE_NONE){
            if (c.isInCentralArea(x,y)){
              s += "background-color:"+conf.boardColorDQ+";";
            } else {
              s += "background-color:"+conf.boardColor+";";
            }
          }
          s += "'></div>";
          jQuery("#"+c.id+"_boardMarks").append(s);
        });
      }
    } else {
      for (var i=0; i<marks.length; i++){
        var mark = marks[i];
        var x = mark[0], y = mark[1];
        var color = c.gameState.board[x][y];
        var area = c.xyToArea(x,y);
        var left = area[0], top = area[1], width = area[2], height = area[3];
        var styleClass = "";
        switch(mark[2]){
          case MARK_CROSS:
            styleClass = "gvsprite-21-markcross";
            break;
          case MARK_TRIANGLE:
            styleClass = "gvsprite-21-marktriangle";
            break;
          case MARK_SQUARE:
            styleClass = "gvsprite-21-marksquare";
            break;
          case MARK_CIRCLE:
            styleClass = "gvsprite-21-markcircle";
            break;
          case MARK_TERR_BLACK:
            styleClass = "gvsprite-21-markblack";
            break;
          case MARK_TERR_WHITE:
            styleClass = "gvsprite-21-markwhite";
            break;
          case MARK_TEXT:
            var s = "<div style='position:absolute;left:"+left+"px;top:"+top+"px;width:"+width+"px;height:"+height+"px;text-align:center;vertical-align:middle;color:red;font-family:Nina;font-weight:bolder;font-size:15px;";
            if (color == STONE_NONE){
              s += "background-color:"+conf.boardColor+";";
            }
            s += "'>"+mark[3]+"</div>";
            jQuery("#"+c.id+"_boardMarks").append(s);
            continue;
        }
        var s = "<div class='"+styleClass+"' style='position:absolute;left:"+left+"px;top:"+top+"px;";
        if (color == STONE_NONE){
          s += "background-color:"+conf.boardColor+";";
        }
        s += "'></div>";
        jQuery("#"+c.id+"_boardMarks").append(s);
      }
    }
    return this;
  },

  setPrisoners: function(b, w){
    if (b == 0)
      b = "0";
    if (w == 0)
      w = "0";
    jQuery("#"+this.id+"_blackPrisoners").empty().append(b);
    jQuery("#"+this.id+"_whitePrisoners").empty().append(w);
    return this;
  },
  
  setBranches: function(){
    var c = this;
    var conf = c.config;
    jQuery("#"+c.id+"_boardBranches").empty();
    jQuery("#"+c.id+"_branches").empty();
    jQuery("#"+c.id+"_branches").css({height:0});
    var gameState = c.gameState;
    var node = gameState.currentNode;
    if (node.hasChildren() && node.children.length >= 2){
      var n = node.children.length;
      for(var i=0; i<node.children.length; i++){
        var title = "";
        if (i == 0){
          title = "&#20998;&#25903;A = &#23454;&#25112; [Alt Shift &#8594;][Alt Shift A]";
        } else {
          if (i < BRANCHES.length){
            var branchName = BRANCHES[i];
            title = "&#20998;&#25903;" + branchName + "[Alt Shift " + branchName + "]";
          }
        }
        var s = "<div class='gvtb-branch gvbutton'><a href='#' title='" + title + "' onclick='gv."+c.id+".goToBranch("+i+");return false;'>"+BRANCHES[i]+"</a></div>";
        jQuery("#"+c.id+"_branches").append(s);
        jQuery("#"+c.id+"_branches").css({height:n*23});
        var child = node.children[i];
        if (child.type == NODE_MOVE){
          var x = child.x, y = child.y;
          if (conf.gameType == DAOQI){
            c.mapToPoints(x,y,function(x,y){
              var styleClass = "gvbranch";
              if (c.isInCentralArea(x,y))
                styleClass = "gvbranch-real";
              var area = c.xyToArea(x,y);
              jQuery("#"+c.id+"_boardBranches").append("<div class='"+styleClass+"' style='left:"+area[0]+"px;top:"+area[1]
                +"px;width:"+area[2]+"px;height:"+area[3]+"px;'>"+BRANCHES[i]+"</div>");              
            });
          } else {
            var area = c.xyToArea(x,y);
            jQuery("#"+c.id+"_boardBranches").append("<div class='gvbranch' style='left:"+area[0]+"px;top:"+area[1]
              +"px;width:"+area[2]+"px;height:"+area[3]+"px;'>"+BRANCHES[i]+"</div>");
          }
        }
      }
    }
    return this;
  },
  
  removeBranches: function(){
    jQuery("#"+this.id+"_boardBranches").empty();
    jQuery("#"+this.id+"_branches").empty();
    jQuery("#"+this.id+"_branches").css({height: 0});
    return this;
  },
  
  setComment: function(comment){
    var c = this;
    var gameState = c.gameState;
    var node = gameState.currentNode;
    if (!comment){
      comment = "<strong>";
      if (node.depth > 1)
        comment += "&#20998;&#25903;";
      comment += "&#31532;"+node.moveNumber+"&#25163;&#35780;&#35770;</strong>";
      if (node.comment != undefined && node.comment != null)
        comment += "<br/>"+node.comment.replace(/\n/g, "<br/>\n");
    }
    jQuery("#"+c.id+"_comment").empty().append(comment);
    jQuery("#"+c.id+"_comment").height(c.rightPaneHeight - jQuery("#"+c.id+"_info").height()-12);
    return this;
  },
  
  removeComment: function(){
    jQuery("#"+this.id+"_comment").empty();
    return this;
  },
  
  redrawBoard: function(){
    var c = this;
    var gameState = c.gameState;
    var board = gameState.board;
    var s = "";
    if (c.config.gameType == DAOQI){
      for(var i=0; i<board.size; i++){
        for(var j=0; j<board.size; j++){
          var color = board[i][j];
          var moveNumber = 0;
          if (c.config.showMoveNumber){
            moveNumber = c.gameState.getMoveNumber(i,j);
          }
          if (color == STONE_BLACK || color == STONE_WHITE){
            c.mapToPoints(i,j,function(x,y){
              s += c.createStone(x,y,color,moveNumber);
            });
          }
        }
      }
    } else {
      for(var i=0; i<board.size; i++){
        for(var j=0; j<board.size; j++){
          var color = board[i][j];
          var moveNumber = 0;
          if (c.config.showMoveNumber){
            moveNumber = c.gameState.getMoveNumber(i,j);
          }
          if (color == STONE_BLACK || color == STONE_WHITE){
            s += c.createStone(i,j,color,moveNumber);
          }
        }
      }
    }
    jQuery("#"+c.id+"_boardPoints").empty();
    if (s.length > 0)
      jQuery("#"+c.id+"_boardPoints").append(s);
    return c;
  },
  
  sendMove_: function(x,y){
    this.play(x,y);
    return this.sendMove();
  },
  
  play: function(x,y){
    var c = this;
    var gameState = c.gameState;
    
    if (gameState == null)
      return c;

    // check whether the position is occupied
    if (gameState.board[x][y] != 0){
      if (gameState.isFirst())
        return false;
      var points = new Array();
      var changed = false;
      for(;;){
        var node = gameState.currentNode;
        if (node.type == NODE_MOVE && node.x == x && node.y == y)
          break;
        if (!c.back_(points))
          break;
        changed = true;
      }
      if (changed){
        jQuery.each(points, function(i,point){
          c.removeStone(point.x,point.y);
          if (point.deleteFlag){
            c.addStone(point.x, point.y, point.color);
          }
        });
        c.setGameState();
        return true;
      }
      return false;
    }
    
    // check whether (x,y) is the same as next move/branches
    if (!gameState.isLast()){
      var children = gameState.currentNode.children;
      for(var i=0; i<children.length; i++){
        var node = children[i];
        if (node.type == NODE_MOVE && node.x == x && node.y == y){
          return c.goToBranch(i);
        }
      }
    }

    if (gameState.play(x,y)){
      var node = gameState.currentNode;
      jQuery.each(node.points, function(i,point){
        c.removeStone(point.x,point.y);
        if (!point.deleteFlag){
          c.addStone(point.x, point.y, point.color);
        }
      });
      c.setGameState();
      return true;
    } else {
      return false;
    }
  },
  
  remove: function(){
    var c = this;
    var gs = c.gameState;
    if (gs != null && gs.canRemove()){
      var node = gs.currentNode;
      jQuery.each(node.points, function(i,point){
        c.removeStone(point.x,point.y);
        if (point.deleteFlag){
          c.addStone(point.x, point.y, point.color);
        }
      });
      gs.remove();
      c.setGameState();
    }
    return c;
  },

  back_: function(points){
    var c = this;
    var gameState = c.gameState;
    if (gameState.isFirst())
      return false;
    var node = gameState.currentNode;
    // before
    for (var i=0; i<node.points.length; i++){
      var point = node.points[i];
      var found = false;
      for(var j=0; j<points.length; j++){
        var p = points[j];
        if (point.x == p.x && point.y == p.y){
          found = true;
          points[j] = point;
          break;
        }
      }
      if (!found){
        points.push(point);
      }
    }
    gameState.back();
    // after
    return true;
  },
  
  back: function(){
    var c = this;
    var gameState = c.gameState;
    if (gameState == null)
      return c;
    if (gameState.isFirst())
      return false;
    var node = gameState.currentNode;
    jQuery.each(node.points, function(i,point){
      c.removeStone(point.x,point.y);
      if (point.deleteFlag){
        c.addStone(point.x, point.y, point.color);
      }
    });
    gameState.back();
    c.setGameState();
    return true;
  },
  
  backN: function(n){
    var c = this;
    if (c.gameState == null)
      return c;
    if (n == undefined)
      n = c.config.fastMode;
    var points = new Array();
    var changed = false;
    for(var i=0; i<n; i++){
      if (!c.back_(points))
        break;
      changed = true;
    }
    if (changed){
      jQuery.each(points, function(i,point){
        c.removeStone(point.x,point.y);
        if (point.deleteFlag){
          c.addStone(point.x, point.y, point.color);
        }
      });
      c.setGameState();
    }
    return c;
  },
  
  backToComment: function(){
    var c = this;
    if (c.gameState == null)
      return c;
    var points = new Array();
    var changed = false;
    for(;;){
      if (!c.back_(points))
        break;
      changed = true;
      // stop at move that has comments or branches
      var node = c.gameState.currentNode;
      if (node.hasComment() || node.hasBranches())
        break;
    }
    if (changed){
      jQuery.each(points, function(i,point){
        c.removeStone(point.x,point.y);
        if (point.deleteFlag){
          c.addStone(point.x, point.y, point.color);
        }
      });
      c.setGameState();
    }
    return c;
  },
  
  backAll: function(){
    var c = this;
    var gameState = c.gameState;
    if (gameState == null)
      return c;
    c.removeAllStones();
    gameState.backAll();
    var node = gameState.currentNode;
    jQuery.each(node.points, function(i, point){
      if (point.color == STONE_BLACK || point.color == STONE_WHITE){
        c.addStone(point.x,point.y,point.color);
      }
    });
    c.setGameState();
    return c;
  },

  forward_: function(points){
    var c = this;
    var gameState = c.gameState;
    if (gameState.isLast())
      return false;
    gameState.forward();
    var node = gameState.currentNode;
    for (var i=0; i<node.points.length; i++){
      var point = node.points[i];
      var found = false;
      for(var j=0; j<points.length; j++){
        var p = points[j];
        if (point.x == p.x && point.y == p.y){
          found = true;
          points[j] = point;
          break;
        }
      }
      if (!found){
        points.push(point);
      }
    }
    return true;
  },
  
  forward: function(){
    var c = this;
    var gameState = c.gameState;
    if (gameState == null)
      return c;
    if (!gameState.forward())
      return false;
    var node = gameState.currentNode;
    jQuery.each(node.points, function(i,point){
      c.removeStone(point.x,point.y);
      if (!point.deleteFlag){
        c.addStone(point.x, point.y, point.color);
      }
    });
    c.setGameState();
    return true;
  },
  
  forwardN: function(n){
    var c = this;
    if (c.gameState == null)
      return c;
    if (n == undefined)
      n = c.config.fastMode;
    var points = new Array();
    var changed = false;
    for(var i=0; i<n; i++){
      if (!c.forward_(points))
        break;
      changed = true;
    }
    if (changed){
      jQuery.each(points, function(i,point){
        c.removeStone(point.x,point.y);
        if (!point.deleteFlag){
          c.addStone(point.x, point.y, point.color);
        }
      });
      c.setGameState();
    }
    return c;
  },
  
  forwardToComment: function(){
    var c = this;
    if (c.gameState == null)
      return c;
    var points = new Array();
    var changed = false;
    for(;;){
      if (!c.forward_(points))
        break;
      changed = true;
      // stop at move that has comments or branches
      var node = c.gameState.currentNode;
      if (node.hasComment() || node.hasBranches())
        break;
    }
    if (changed){
      jQuery.each(points, function(i,point){
        c.removeStone(point.x,point.y);
        if (!point.deleteFlag){
          c.addStone(point.x, point.y, point.color);
        }
      });
      c.setGameState();
    }
    return c;
  },
  
  forwardAll: function(){
    var c = this;
    var gameState = c.gameState;
    if (gameState == null)
      return c;
    c.removeAllStones();
    gameState.forwardAll();
    this.redrawBoard();
    c.setGameState();
    return c;
  },
  
  goToBranch: function(n){
    var c = this;
    var gameState = c.gameState;
    if (gameState == null)
      return c;
    if (!gameState.goToBranch(n))
      return c;
    var node = gameState.currentNode;
    jQuery.each(node.points, function(i,point){
      c.removeStone(point.x,point.y);
      if (!point.deleteFlag){
        c.addStone(point.x, point.y, point.color);
      }
    });
    c.setGameState();
    return c;
  },
  
  goTo: function(n){
    var c = this;
    var gameState = c.gameState;
    if (gameState == null)
      return c;
    while (gameState.isOnBranch()){
      c.back();
    }
    if (n >= gameState.game.getMoves()){
      c.forwardAll();
    } else if (n <= 0) {
      c.backAll();
    } else if (n > gameState.currentNode.moveNumber) {
      var points = new Array();
      var changed = false;
      while(n > gameState.currentNode.moveNumber){
        if (!c.forward_(points))
          break;
        changed = true;
      }
      if (changed){
        jQuery.each(points, function(i,point){
          c.removeStone(point.x,point.y);
          if (!point.deleteFlag){
            c.addStone(point.x, point.y, point.color);
          }
        });
        c.setGameState();
      }
    } else if (n < gameState.currentNode.moveNumber) {
      var points = new Array();
      var changed = false;
      while(n < gameState.currentNode.moveNumber){
        if (!c.back_(points))
          break;
        changed = true;
      }
      if (changed){
        jQuery.each(points, function(i,point){
          c.removeStone(point.x,point.y);
          if (point.deleteFlag){
            c.addStone(point.x, point.y, point.color);
          }
        });
        c.setGameState();
      }
    }
    return c;
  },
  
  setToggleNumberImg: function(){
    var c = this;
    if (c.config.showMoveNumber){
      jQuery("#"+c.id+"_toggleNumberImg").removeClass("gvsprite-hidenumber");
      jQuery("#"+c.id+"_toggleNumberImg").addClass("gvsprite-shownumber");
    } else {
      jQuery("#"+c.id+"_toggleNumberImg").removeClass("gvsprite-shownumber");
      jQuery("#"+c.id+"_toggleNumberImg").addClass("gvsprite-hidenumber");
    }
    return c;
  },
  
  toggleNumber: function(){
    var c = this;
    if (c.config.showMoveNumber){
      c.config.showMoveNumber = false;
    } else {
      c.config.showMoveNumber = true;
    }
    c.setToggleNumberImg();
    if (c.gameState == null)
      return c;
    c.redrawBoard();
    return c;
  },
  
  showNumber: function(){
    var c = this;
    if (c.config.hideMoveNumber){
      c.toggleNumber();
    }
    return c;
  },
  
  hideNumber: function(){
    var c = this;
    if (c.config.showMoveNumber){
      c.toggleNumber();
    }
    return c;
  },
  
  eventToXY: function(e){
    var conf = this.config;
    e = e || window.event;
    if (e.layerX == undefined)
      e.layerX = e.offsetX;
    if (e.layerY == undefined)
      e.layerY = e.offsetY;
    var x = parseInt(e.layerX/conf.gridSize);
    var y = parseInt(e.layerY/conf.gridSize);
    if (conf.gameType == DAOQI){
      x = (x+conf.boardSize-conf.x0)%conf.boardSize;
      y = (y+conf.boardSize-conf.y0)%conf.boardSize;
    }
    return [x,y];
  },
  
  isInCentralArea: function(x,y){
    var conf = this.config;
    return x >= conf.vbw && x < conf.boardSize+conf.vbw && y >= conf.vbw && y < conf.boardSize+conf.vbw;
  },
  
  xyToArea: function(x,y){
    var conf = this.config;
    return [x*conf.gridSize, y*conf.gridSize, conf.gridSize, conf.gridSize];
  },
  
  xyToLabel: function(x,y){
    var conf = this.config;
    var s = LABELS[x];
    s += conf.boardSize - parseInt(y);
    return s;
  },
  
  postThickBoxFix: function(){
    this.registerKeyListener();
  },

  goToPopup: function(){
    var url = "#TB_inline?test=0&width=250&height=56&inlineId="+this.id+"_goTo&focus="+this.id+"_goToInput&modal=true&test1=0";
    tb_show("",url,null);
  },
  
  goToOkHandler: function(){
    try {
      var input = document.getElementsByName(this.id+"_goToForm")[1].goToInput.value;
      tb_remove();
      var moveNumber = parseInt(input);
      this.goTo(moveNumber);
    }
    catch(e){
      throw "GameController().goToOkHandler(): " + e;
    }
    this.postThickBoxFix();
  },
  
  goToKeyDown:function(input, e){
    var keyCode;
    if (window.event)
      keyCode = window.event.keyCode;
    else if (e)
      keyCode = e.which;
    else
      return;
  
    if (keyCode == 13){
      gvGoToInput = input.value;
      this.goToOkHandler();
    } else if (keyCode == 27){
      tb_remove();
      this.postThickBoxFix();
    } 
  }
});