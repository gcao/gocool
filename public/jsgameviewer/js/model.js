var STONE_NONE  = 0;
var STONE_BLACK = 1;
var STONE_WHITE = 2;
var STONE_ERASE = 3;

var MODE_NORMAL = 0;
var MODE_EDIT   = 1;
var MODE_SCORE  = 2;

var NODE_EMPTY  = 0;
var NODE_MOVE   = 1;
var NODE_PASS   = 2;

var MARK_NONE       = 0;
var MARK_SQUARE     = 1;
var MARK_CIRCLE     = 2;
var MARK_TRIANGLE   = 3;
var MARK_CROSS      = 4;
var MARK_TEXT       = 5;
var MARK_NUMBER     = 6;
var MARK_TERR_BLACK = 7;
var MARK_TERR_WHITE = 8;
var MARK_STONE      = 9;

var MoveNumber = Class.create();
MoveNumber.prototype = {
  initialize: function(val, depth){
    this.val = val;
    this.depth = 0;
    if (depth != undefined && depth != null)
      this.depth = depth;
  }
}

/* Point class
 * x
 * y
 * id: "x-y"
 * color
 * moveNumber
 */
var Point = Class.create();
Point.prototype = {
  initialize: function(x,y,color,moveNumber,deleteFlag){
    this.x = x;
    this.y = y;
    this.id = x + "-" + y;
    this.color = 0;
    if (color != undefined && color != null)
      this.color = color;
    this.moveNumber = null;
    if (moveNumber != undefined && moveNumber != null)
      this.moveNumber = moveNumber;
    this.deleteFlag = false;
    if (deleteFlag)
      this.deleteFlag = true;
  }
}

/* Board class
 * gameType
 * size - board size
 * [][] - state: STONE_NONE, STONE_BLACK, STONE_WHITE
 */
var Board = Class.create();
Object.extend(Board, Array);
Board.prototype = {
  initialize: function(gameType, size){
    this.gameType = gameType;
    this.size = size;
    this.reset();
  },

  isNeighbor: function(x1,y1,x2,y2){
    if (this.gameType == DAOQI){
      if (x1 == x2)
        return y1 == (y2+1)%this.size || y1 == (y2-1+this.size)%this.size;
      if (y1 == y2)
        return x1 == (x2+1)%this.size || x1 == (x2-1+this.size)%this.size;
      return false;
    } else {
      if (x1 == x2)
        return y1 == y2+1 || y1 == y2-1;
      if (y1 == y2)
        return x1 == x2+1 || x1 == x2-1;
      return false;
    }
  },
  
  normalize: function(index){
    if (index < 0)
      return index + this.size;
    if (index >= this.size)
      return index - this.size;
    return index;
  },
  
  reset: function(){
    for(i=0; i<this.size; i++) {
      this[i] = new Array(this.size);
      for(j=0; j<this.size; j++)
        this[i][j] = 0;
    }
  },
  
  copyFrom: function(b){
    // copy values from another board
    for(var i=0; i<this.size; i++){
      for(var j=0; j<this.size; j++){
        this[i][j] = b[i][j];
      }
    }
  },
  
  /* This function does:
   * 1. validate if board, x, y are valid. if not return null;
   * 2. check board[x][y], if it's 0, return null;
   * 3. get group start from x,y;
   * 4. if the group has zero liberty, return it, otherwise, return null.
   * The returned group should has properties like:
   * group.color = color
   * group["1-2"] = [1,2]
   * ...
   */
  getDeadGroup: function(x, y){
    if (this.gameType == DAOQI){
      x = this.normalize(x);
      y = this.normalize(y);
    } else {
      if (x < 0 || x>=this.size || y<0 || y>= this.size)
        return null;  
    }

    if (this[x][y] == 0)
      return null;

    if (this.gameType == DAOQI){
      if (this[this.normalize(x-1)][y] == 0 ||
        this[this.normalize(x+1)][y] == 0 ||
        this[x][this.normalize(y-1)] == 0 ||
        this[x][this.normalize(y+1)] == 0
      )
        return null;
    } else {
      if ((x > 0 && this[x-1][y] == 0) ||
        (x < this.size-1 && this[x+1][y] == 0) ||
        (y > 0 && this[x][y-1] == 0) ||
        (y < this.size-1 && this[x][y+1] == 0)
      )
        return null;
    }
  
    var group = new Array();
    group.color = this[x][y];
    group.push([x,y]);
    group[x+"-"+y] = true;
  
    if (this.gameType == DAOQI){
      if (this.expandDeadGroup(group, x-1, y))
        return null;
      if (this.expandDeadGroup(group, x+1, y))
        return null;
      if (this.expandDeadGroup(group, x, y-1))
        return null;
      if (this.expandDeadGroup(group, x, y+1))
        return null;
    } else {
      if (x > 0 && this.expandDeadGroup(group, x-1, y))
        return null;
      if (x < this.size-1 && this.expandDeadGroup(group, x+1, y))
        return null;
      if (y > 0 && this.expandDeadGroup(group, x, y-1))
        return null;
      if (y < this.size-1 && this.expandDeadGroup(group, x, y+1))
        return null;
    }
    return group;
  },
  
  /* This function does:
   * if group["x-y"] != null, means already checked,
   *   return false;
   * if this[x][y] is not the same as group.color,
   *   return false;
   * else if any neighbor is 0,
   *   return true;
   * else
   *   group["x-y"] = [x,y];
   *   recursively call expandGroup on its neighbors
   *
   * Return true  - the group has liberty(ies)
   *        false - the group has no liberty after checking x,y
   */
  expandDeadGroup: function(group, x, y){
    if (this.gameType == DAOQI){
      x = this.normalize(x);
      y = this.normalize(y);
    }
    if (group[x+"-"+y] != null) // already added to the group
      return false;
    if (this[x][y] != group.color)
      return false;
  
    if (this.gameType == DAOQI){
      if (this[this.normalize(x-1)][y] == 0 ||
        this[this.normalize(x+1)][y] == 0 ||
        this[x][this.normalize(y-1)] == 0 ||
        this[x][this.normalize(y+1)] == 0
      )
        return true;
    } else {
      if ((x > 0 && this[x-1][y] == 0) ||
        (x < this.size-1 && this[x+1][y] == 0) ||
        (y > 0 && this[x][y-1] == 0) ||
        (y < this.size-1 && this[x][y+1] == 0)
      )
        return true;
    }
  
    group.push([x,y]);
    group[x+"-"+y] = true;
  
    if (this.gameType == DAOQI){
      if (this.expandDeadGroup(group, x-1, y))
        return true;
      if (this.expandDeadGroup(group, x+1, y))
        return true;
      if (this.expandDeadGroup(group, x, y-1))
        return true;
      if (this.expandDeadGroup(group, x, y+1))
        return true;
    } else {
      if (x > 0 && this.expandDeadGroup(group, x-1, y))
        return true;
      if (x < this.size-1 && this.expandDeadGroup(group, x+1, y))
        return true;
      if (y > 0 && this.expandDeadGroup(group, x, y-1))
        return true;
      if (y < this.size-1 && this.expandDeadGroup(group, x, y+1))
        return true;
    }
  
    return false;
  }
}

/* Node class
 * ------------ static properties
 * type - node type: NODE_EMPTY, NODE_MOVE, NODE_PASS
 * parent - parent node
 * children - child nodes
 * moveNumber - move number
 * depth - 0:trunk, 1:branch on trunk, 2: branch on branch,...
 * comment
 * points - setup points + current move + removed prisoners (null if type is NODE_EMPTY or NODE_PASS) 
 * marks - [x, y, markType, markText]
 * ------------ dynamic properties
 * processed - updated node based on previous board state and current move
 * blackPrisoners - black prisoners of this move (zero if type is NODE_EMPTY or NODE_PASS)
 * blackPrisonerPoints
 * whitePrisoners - white prisoners of this move (zero if type is NODE_EMPTY or NODE_PASS)
 * whitePrisonerPoints
 *
 * ------------ NODE_MOVE and NODE_PASS only
 * color
 * ------------ NODE_MOVE only
 * x
 * y
 */
var Node = Class.create();
Node.prototype = {
  initialize: function(parent){
    this.type = NODE_EMPTY;
    this.parent = parent;
    this.children = new Array();
    this.moveNumber = 0;
    this.depth = 0;
    this.points = new Array();
    this.processed = false;
    this.blackPrisoners = 0;
    this.blackPrisonerPoints = [];
    this.whitePrisoners = 0;
    this.whitePrisonerPoints = [];
  },
  
  isRoot: function(){
    return this.parent == null;
  },
  
  hasChildren: function(){
    return this.children.length > 0;
  },
  
  firstChild: function(){
    if (this.children.length > 0)
      return this.children[0];
    return null;
  },
  
  isOnBranch: function(){
    return this.depth > 1;
  },
  
  isDummyNode: function(){
    return this.type == NODE_EMPTY && !this.isRoot() && this.comment == null && this.marks == null;
  },
  
  hasComment: function(){
    return this.comment != undefined && this.comment !=null && jQuery.trim(this.comment).length > 0;
  },
  
  hasBranches: function(){
    return this.children.length > 1;
  },
  
  toString: function(){
    var indent = "";
    var typeName = "EMPTY";
    if (this.type == NODE_MOVE)
      typeName = "MOVE";
    else if (this.type == NODE_PASS)
      typeName = "PASS";
    var str = indent+"Node("+typeName+", "+this.moveNumber;
    if (this.type == NODE_MOVE || this.type == NODE_PASS)
      str += ", "+(this.color == STONE_BLACK?"black":"white");
    if (this.type == NODE_MOVE)
      str += ", "+this.x+","+this.y;
    str += ")";
    return str;
  }
}

/* Game class
 * ------------ General game information
 * url - game url
 * type
 * charset
 * name
 * boardSize
 * rule - Chinese, Japanese, Korean, American
 * handicap
 * komi
 * blackName
 * blackRank
 * whiteName
 * whiteRank
 * handicap
 * date
 * place
 * result
 * moves
 * dataSize - sgf string length of the game
 * ------------
 * rootNode
 */
var Game = Class.create();
Game.prototype = {
  initialize: function(gameType){
    this.type = gameType;
    this.charset = "";
    this.name = "";
    this.boardSize = 19;
    this.rule = "";
    this.handicap = 0;
    this.komi = 0;
    this.blackName = "";
    this.blackRank = "";
    this.whiteName = "";
    this.whiteRank = "";
    this.date = "";
    this.place = "";
    this.result = "";
    this._moves = 0;
    this._firstPlayer = STONE_NONE;
    this.rootNode = new Node(null);
  },
  
  isFinished: function(){
    return this.result && this.result.length > 0;
  },

  getMoves: function(){
    if (this._moves == 0){
      var node = this.rootNode;
      while(node.hasChildren()) {
        node = node.children[0];
        if (node.moveNumber != undefined && node.moveNumber != null)
          this._moves = node.moveNumber;
      }
    }
    return this._moves;
  },
  
  getFirstPlayer: function(){
    if (this._firstPlayer == STONE_NONE){
      var node = this.rootNode;
      while(this._firstPlayer == STONE_NONE && node.hasChildren()){
        node = node.children[0];
        if(node.type == NODE_MOVE || node.type == NODE_PASS)
          this._firstPlayer = node.color;
      }
    }
    return this._firstPlayer;
  },
  
  getId: function(){
    var id = this.url;
    return id;
  },
  
  getTitle: function(){
    var title = "";
    if (this.name)
      title += this.name + ": ";
    if (this.whiteName)
      title += this.whiteName;
    else
      title += "Unknown Player";
    title += "(W) - ";
    if (c.game.blackName)
      title += c.game.blackName;
    else
      title += "Unknown Player";
    title += "(B)";
    if (this.result)
      title += "   " + this.result;
    if (this.date)
      title += "   " + this.date;
    if (this.place)
      title += "   " + this.place;
    return title;
  },
  
  getNextPlayer: function(){
    var color = STONE_NONE;
    var node = this.rootNode;
    while(node.hasChildren()){
      if (node.color == STONE_BLACK || node.color == STONE_WHITE){
        color = node.color;
      }
      var child = node.children[0];
      if (child.temp){
        break;
      }
      node = child;
    }
    if (node.color == STONE_BLACK || node.color == STONE_WHITE){
      color = node.color;
    }
    var nextPlayerColor = color == STONE_BLACK? STONE_WHITE:STONE_BLACK;
    return nextPlayerColor;
  }
}

/* GameState class
 * ------------ properties that don't change
 * game
 * ------------ properties that change between moves
 * currentNode
 * board - board state after applied currentNode
 * moveNumbers - example: moveNumbers["1-5"] = new MoveNumber(100)
 * blackPrisoners - black prisoners
 * blackPrisonerPoints
 * whitePrisoners - white prisoners
 * whitePrisonerPoints
 * tempMoves - temporary moves(will disappear after reload the game)
 * ------------
 * last.node
 * last.board
 * last.moveNumbers
 * last.blackPrisoners
 * last.blackPrisonerPoints
 * last.whitePrisoners
 * last.whitePrisonerPoints
 */
var GameState = Class.create();
GameState.prototype = {
  initialize: function(game){
    this.game = game;
    this.board = new Board(game.type, game.boardSize);
    this.currentNode = game.rootNode;
    this.rootNode = this.currentNode;
    this.blackPrisoners = 0;
    this.blackPrisonerPoints = [];
    this.whitePrisoners = 0;
    this.whitePrisonerPoints = [];
    this.moveNumbers = new Object();
    this.tempMoves = new Array();
    this.processCurrentNode(); // process the root node
  },
  
  isFirst: function(){
    return this.currentNode.isRoot();
  },
  
  isLast: function(){
    return !this.currentNode.hasChildren();
  },
  
  isOnBranch: function(){
    return this.currentNode.isOnBranch();
  },

  getNextPlayer: function(){
    var node = this.currentNode;
    var color = node.color;
    while(color != STONE_BLACK && color != STONE_WHITE && !node.isRoot()){
      node = node.parent;
      color = node.color;
    }
    if (color == STONE_BLACK)
      color = STONE_WHITE;
    else if (color == STONE_WHITE)
      color = STONE_BLACK;
    else {
      node = this.currentNode;
      while(color != STONE_BLACK && color != STONE_WHITE && node.hasChildren()){
        node = node.children[0];
        color = node.color;
      }
    }
    if (!color || color == STONE_NONE)
      color = STONE_BLACK;
    return color;
  },
  
  getMoveNumber: function(x,y){
    var m = this.moveNumbers[getId(x,y)];
    if (m instanceof Number)
      return m;
    if (m != undefined && m != null)
      return m.val;
    return 0;
  },
  
  /* This function update game state if a group of stones are dead after current move.
   */
  handleDeadGroup: function(group){
    var gs = this;
    if (group != null){
      if (group.color == STONE_BLACK) {
        gs.currentNode.blackPrisoners += group.length;
        gs.blackPrisoners += group.length;
      } else {
        gs.currentNode.whitePrisoners += group.length;
        gs.whitePrisoners += group.length;
      }
      jQuery.each(group, function(i,item){
        var x = item[0], y = item[1], moveNumber = gs.moveNumbers[getId(x,y)];
        // x, y, color of the dead stone, the move number of the dead stone, the move number that the stone is marked dead
        var p = [x, y, group.color, moveNumber, gs.currentNode.moveNumber];
        if (group.color == STONE_BLACK){
          gs.currentNode.blackPrisonerPoints.push(p);
          gs.blackPrisonerPoints.push(p);
        } else {
          gs.currentNode.whitePrisonerPoints.push(p);
          gs.whitePrisonerPoints.push(p);
        }
        gs.board[x][y] = 0;
        var point = new Point(x, y, group.color, moveNumber, true);
        gs.currentNode.points.push(point);
        delete gs.moveNumbers[getId(x, y)];
      });
    }
  },
  
  processCurrentNode: function(){
    var gs = this;
    var board = this.board;
    var node = this.currentNode;
    if (node.processed){
      // update board state, move numbers, prisoners
      for(var i=0; i<node.points.length; i++){
        var point = node.points[i];
        if (point.deleteFlag)
          board[point.x][point.y] = 0;
        else
          board[point.x][point.y] = point.color;
        this.moveNumbers[getId(point.x,point.y)] = point.moveNumber;
      }
      if (node.blackPrisoners > 0) {
        this.blackPrisoners += node.blackPrisoners;
        this.blackPrisonerPoints = this.blackPrisonerPoints.concat(node.blackPrisonerPoints);
      }
      if (node.whitePrisoners > 0) {
        this.whitePrisoners += node.whitePrisoners;
        this.whitePrisonerPoints = this.whitePrisonerPoints.concat(node.whitePrisonerPoints);
      }
      return;
    }
    node.processed = true;
    switch(node.type){
    case NODE_EMPTY: // add/remove stones only
      jQuery.each(node.points, function(i,point){
        var x = point.x, y = point.y, color = point.color;
        if (x < 0 || x >= board.size || y < 0 || y >= board.size)
          return;
        switch(color){
        case STONE_ERASE:
          point.color = board[x][y];
          point.deleteFlag = true;
          var p = [x,y,point.color,gs.moveNumbers[getId(x,y)],node.moveNumber];
          if (point.color == STONE_BLACK){
            node.blackPrisoners ++;
            gs.blackPrisoners ++;
            node.blackPrisonerPoints.push(p);
            gs.blackPrisonerPoints.push(p);
          } else if (point.color == STONE_WHITE){
            node.whitePrisoners ++;
            gs.whitePrisoners ++;
            node.whitePrisonerPoints.push(p);
            gs.whitePrisonerPoints.push(p);
          }
          board[x][y] = 0;
          break;
        case STONE_BLACK:
        case STONE_WHITE:
          board[x][y] = color;
          break;
        }
      });
      break;
    case NODE_MOVE: // add new move and compute all neighbors' state
      var x = node.x, y = node.y, color = node.color, size = this.game.boardSize;
      if (x < 0 || x >= size || y < 0 || y >= size)
        throw "Invalid point: ("+x+","+y+")";
      board[x][y] = color;
      var moveNumber = new MoveNumber(node.moveNumber,node.depth);
      gs.moveNumbers[getId(x,y)] = moveNumber;
      var point = new Point(x,y,color,moveNumber);      
      node.points.push(point);
      var opponentColor = (color==STONE_BLACK)?STONE_WHITE:STONE_BLACK;
      if (gs.game.type == DAOQI){
        var x1 = board.normalize(x-1);
        var y1 = y;
        if (board[x1][y1] == opponentColor)
          this.handleDeadGroup(board.getDeadGroup(x1, y1));
        x1 = board.normalize(x+1);
        y1 = y;
        if (board[x1][y1] == opponentColor)
          this.handleDeadGroup(board.getDeadGroup(x1, y1));
        x1 = x;
        y1 = board.normalize(y-1);
        if (board[x1][y1] == opponentColor)
          this.handleDeadGroup(board.getDeadGroup(x1, y1));
        x1 = x;
        y1 = board.normalize(y+1);
        if (board[x1][y1] == opponentColor)
          this.handleDeadGroup(board.getDeadGroup(x1, y1));
      } else {        
        if (x > 0){
          var x1 = x-1, y1 = y;
          if (board[x1][y1] == opponentColor)
            this.handleDeadGroup(board.getDeadGroup(x1, y1));
        }
        if (x < board.size-1){
          var x1 = x+1, y1 = y;
          if (board[x1][y1] == opponentColor)
            this.handleDeadGroup(board.getDeadGroup(x1, y1));
        }
        if (y > 0){
          var x1 = x, y1 = y-1;
          if (board[x1][y1] == opponentColor)
            this.handleDeadGroup(board.getDeadGroup(x1, y1));
        }
        if (y < board.size-1){
          var x1 = x, y1 = y+1;
          if (board[x1][y1] == opponentColor)
            this.handleDeadGroup(board.getDeadGroup(x1, y1));
        }
      }
      this.handleDeadGroup(board.getDeadGroup(x, y));
      break;
    case NODE_PASS: // nothing has to be done
      break;
    }
    
    if (!node.hasChildren()){
      if (!node.isOnBranch() && this.last == null){
        // copy state to this.last
        gs.last = new Object();
        gs.last.node = node;
        gs.last.board = clone(board);
        gs.last.moveNumbers = clone(this.moveNumbers);
        gs.last.blackPrisoners = this.blackPrisoners;
        gs.last.blackPrisonerPoints = clone(this.blackPrisonerPoints);
        gs.last.whitePrisoners = this.whitePrisoners;
        gs.last.whitePrisonerPoints = clone(this.whitePrisonerPoints);
      }
    }
  },
  
  play: function(x,y){
    var board = this.board;
    if (x < 0 || x >= board.size || y < 0 || y >= board.size)
      return false;
    // validate occupied
    if (board[x][y] != 0)
      return false;

    var c = this.getNextPlayer();
    var opponentColor = (c==STONE_BLACK)?STONE_WHITE:STONE_BLACK;
    // undo set board color if validation fails
    board[x][y] = c;
    var killed = 0;
    if (x > 0 && board[x-1][y]==opponentColor){
      var group = board.getDeadGroup(x-1,y);
      if (group != null){
        killed = group.length;        
      }
    }
    if (killed < 2 && x < board.size-1 && board[x+1][y]==opponentColor){
      var group = board.getDeadGroup(x+1,y);
      if (group != null){
        killed = +group.length;
      }
    }
    if (killed < 2 && y > 0 && board[x][y-1]==opponentColor){
      var group = board.getDeadGroup(x,y-1);
      if (group != null){
        killed = +group.length;
      }
    }
    if (killed < 2 && y < board.size-1 && board[x][y+1]==opponentColor){
      var group = board.getDeadGroup(x,y+1);
      if (group != null){
        killed = +group.length;
      }
    }
    var isValidMove = true;
    if (killed == 1){
      // validate Da Jie
      if (this.currentNode.type == NODE_MOVE){
        if (board.isNeighbor(x,y,this.currentNode.x,this.currentNode.y)
          && (this.currentNode.blackPrisoners == 1 || this.currentNode.whitePrisoners == 1)
        )
          isValidMove = false;
      }
    } else if (killed == 0){
      // validate suicide
      var group = board.getDeadGroup(x,y);
      if (group != null && group.length > 0)
        isValidMove = false;
    }
    if (!isValidMove){
      board[x][y] = 0;
      return false;
    }

    var newNode = new Node(this.currentNode);
    newNode.temp = true;
    newNode.type = NODE_MOVE;
    newNode.x = x;
    newNode.y = y;
    newNode.color = c;
    newNode.moveNumber = this.currentNode.moveNumber+1;
    if (this.currentNode.children.length == 0){
      newNode.depth = this.currentNode.depth;
    } else {
      newNode.depth = this.currentNode.depth + 1;
    }
    if (!newNode.isOnBranch()){
      this.last = null;
    }
    this.currentNode.children.push(newNode);
    this.tempMoves.push([x,y]);
    return this.goToBranch(this.currentNode.children.length - 1);
  },
  
  canRemove: function(){
    if (this.currentNode.temp)
      return true;
    else
      return false;
  },
  
  remove: function(){
    if (this.canRemove()){
      var node = this.currentNode;
      var parent = node.parent;
      var i = 0;
      for(i=0; i<parent.children.length; i++){
        if (parent.children[i] == node)
          break;
      }
      this.back();
      parent.children.splice(i,1);
      if (!node.isOnBranch()){
        this.last = null;
      }
    }
  },
  
  back: function(){
    if (this.currentNode.isRoot())
      return false;
    for(var i=0; i<this.currentNode.points.length; i++){
      var point = this.currentNode.points[i];
      if (point.deleteFlag){
        this.board[point.x][point.y] = point.color;
        this.moveNumbers[getId(point.x,point.y)] = point.moveNumber;
      } else {
        this.board[point.x][point.y] = STONE_NONE;
        delete this.moveNumbers[getId(point.x,point.y)];
      }
    }
    if (this.currentNode.blackPrisoners > 0) {
      this.blackPrisoners -= this.currentNode.blackPrisoners;
      for(var i=0; i<this.currentNode.blackPrisoners; i++){
        if (this.blackPrisonerPoints.length > 0)
          this.blackPrisonerPoints.pop();
      }
    }
    if (this.currentNode.whitePrisoners > 0) {
      this.whitePrisoners -= this.currentNode.whitePrisoners;
      for(var i=0; i<this.currentNode.whitePrisoners; i++){
        if (this.whitePrisonerPoints.length > 0)
          this.whitePrisonerPoints.pop();
      }
    }
    this.currentNode = this.currentNode.parent;
    return true;
  },
  
  backAll: function(){
    this.currentNode = this.rootNode;
    this.board.reset();
    this.moveNumbers = new Object();
    this.blackPrisoners = 0;
    this.blackPrisonerPoints = [];
    this.whitePrisoners = 0;
    this.whitePrisonerPoints = [];
    var board = this.board;
    jQuery.each(this.currentNode.points, function(i,point){
      board[point.x][point.y] = point.color;
    });
  },

  forward: function(){
    if (!this.currentNode.hasChildren())
      return false;
    this.currentNode = this.currentNode.children[0];
    this.processCurrentNode();
    return true;
  },
  
  forwardAll: function(){
    if (this.isOnBranch() || this.last == null){
      while(this.forward())
        ;
    } else {
      this.currentNode = this.last.node;
      this.board.copyFrom(this.last.board);
      this.moveNumbers = clone(this.last.moveNumbers);
      this.blackPrisoners = this.last.blackPrisoners;
      this.blackPrisonerPoints = clone(this.last.blackPrisonerPoints);
      this.whitePrisoners = this.last.whitePrisoners;
      this.whitePrisonerPoints = clone(this.last.whitePrisonerPoints);
    }
  },
  
  goToBranch: function(n){
    if (!this.currentNode.hasChildren())
      return false;
    if (this.currentNode.children.length <= n)
      return false;
    this.currentNode = this.currentNode.children[n];
    this.processCurrentNode();
    return true;
  }
}

var GameHistory = new Array();
GameHistory.max = 30;
GameHistory.save = function(gameState){
  var id = gameState.game.getId();
  var matched = null;
  for(var i=0; i<this.length; i++){
    if (this[i] == id){
      matched = i;
      break;
    }
  }
  if (matched != null && matched > 0){
    for(var i=0; i<matched-1; i++){
      this[i+1] = this[i];
    }
  } else {
    this.unshift(id); // insert to the beginning  
    if (this.length > this.max){ // remove last
      var last = this.pop();
      delete this[last];
    }
  }
  this[0] = id;
  this[id] = gameState;
}
