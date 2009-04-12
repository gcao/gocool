var CHAR_A_CODE = 97;

var STATE_VAR_BEGIN = 0;
var STATE_NODE      = 1;
var STATE_VAR_END   = 2;

var PROPERTY_MOVE_BLACK = 0;
var PROPERTY_MOVE_WHITE = 1;
var PROPERTY_EDIT_BLACK = 2;
var PROPERTY_EDIT_WHITE = 3;
var PROPERTY_EDIT_ERASE = 4;
var PROPERTY_COMMENT    = 5;
var PROPERTY_EDIT_MARK  = 6;

var MARK_NONE       = 0;
var MARK_CROSS      = 1;
var MARK_TRIANGLE   = 2;
var MARK_SQUARE     = 3;
var MARK_CIRCLE     = 4;
var MARK_TEXT       = 5;
var MARK_TERR_BLACK = 6;
var MARK_TERR_WHITE = 7;

var GM_DAOQI        = "10";

/* SGFParser class
 */
var SGFParser = Class.create();
SGFParser.prototype = {
	initialize: function(gameType){
		this.gameType = gameType;
	},
	
	/**
	 *  Calculate the minimum of the given three values
	 *
	 *@param  n1  First number
	 *@param  n2  Second number
	 *@param  n3  Third number
	 *@return     Smallest of the given three numbers
	 */
	minPos: function(n1, n2, n3) {
		var min;
		
		if (n1 != -1)
		    min = n1;
		else if (n2 != -1)
		    min = n2;
		else
		    min = n3;
		
		if (n1 < min && n1 != -1)
		    min = n1;
		
		if (n2 < min && n2 != -1)
		    min = n2;
		
		if (n3 < min && n3 != -1)
		    min = n3;
		
		return min;
	},
	
	/**
	 *  Find next character that is not a whitespace, CR or tab
	 *
	 *@param  input  Parsed string
	 *@param  i        Current position
	 *@return          Found position
	 */
	nextNonSpace: function(input, i) {
		while(true){
			c = input.charAt(i);
			if (c == ' ' || c == '\t' || c == '\n' || c == '\r')
				i++;
			else
				break;
		}
	
		return i;
	},
	
	createErrorMsg: function(input, pos, e){
		var s = "SGFParser: ";
		if (e != undefined && e != null)
			s += e;
		s += "\n";
		if (pos > 0)
			s = input.substring(0,pos-1);
		s += "{PARSING FAILED HERE}";
		if (pos < input.length)
			s += input.substring(pos);
		return s;
	},
	
	/**
	 *  Parse a string for a SGF property
	 *
	 *@param  toParse  String to parse
	 *@param  prop     Property to search
	 *@return          Value of found property. If not found, empty string ("")
	 *                 is returned
	 */
	parseProperty: function(input, prop) {
		var pos;
		var inputLength = input.length;
		var result = "";
	
		pos = input.indexOf(prop + "[");
		if (pos == -1)
			return result;
		pos += 2;
		
		if (input.charAt(pos) != '[') {
			throw this.createErrorMsg(input, pos);
		}
		
		while (input.charAt(++pos) != ']' && pos < inputLength)
			result += input.charAt(pos);
	
		if (pos > inputLength) {
			throw this.createErrorMsg(input, pos);
		}
		
		return result;
	},
	
	/**
	 *  Read header properties and values from sgf file
	 *
	 *@param  input  String with sgf file text
	 *@return        True if successful, else false
	 */
	initGame: function(input) {
		var game = new Game(this.gameType);
	
		// Game Type
		tmp = this.parseProperty(input, "GM");
		if (tmp.length > 0 && GM_DAOQI == tmp)
			game.type = DAOQI;

		// Board size
		var tmp = this.parseProperty(input, "SZ");
		if (tmp.length > 0) {
			try {
				game.boardSize = parseInt(tmp);
			} catch(e){
				throw this.createErrorMsg(input, input.indexOf("SZ["));
			}
		}
	
		// Game Name
		tmp = this.parseProperty(input, "GN");
		if (tmp.length > 0)
			game.name = tmp;
	
		// Charset
		tmp = this.parseProperty(input, "CA");
		if (tmp.length > 0)
			game.charset = tmp;
	
		// White player name
		tmp = this.parseProperty(input, "PW");
		if (tmp.length > 0)
			game.whiteName = tmp;
	
		// White player rank
		tmp = this.parseProperty(input, "WR");
		if (tmp.length > 0)
			game.whiteRank = tmp;
	
		// Black player name
		tmp = this.parseProperty(input, "PB");
		if (tmp.length > 0)
			game.blackName = tmp;
	
		// Black player rank
		tmp = this.parseProperty(input, "BR");
		if (tmp.length > 0)
			game.blackRank = tmp;
	
		// Rule
		tmp = this.parseProperty(input, "RU");
		if (tmp.length > 0)
			game.rule = tmp;
	
		// Komi
		tmp = this.parseProperty(input, "KM");
		if (tmp.length > 0) {
			try {
				game.komi = parseFloat(tmp);
			} catch(e){
				throw this.createErrorMsg(input, input.indexOf("KM["));
			}
		}
	
		// Handicap
		tmp = this.parseProperty(input, "HA");
		if (tmp.length > 0) {
			try {
				game.handicap = parseInt(tmp);
			} catch(e){
				throw this.createErrorMsg(input, input.indexOf("HA["));
			}
		}
	
		// Result
		tmp = this.parseProperty(input, "RE");
		if (tmp.length > 0)
			game.result = tmp;
	
		// Date
		tmp = this.parseProperty(input, "DT");
		if (tmp.length > 0)
			game.date = tmp;
	
		// Place
		tmp = this.parseProperty(input, "PC");
		if (tmp.length > 0)
			game.place = tmp;
	
		return game;
	},
	
	parse: function(input){
		var pos = 0;
		try {
			// escape HTML entities
			input = input.replace(/&/g,"&amp;");
			input = input.replace(/</g,"&lt;");
			// parse general properties and init a game
			var game = this.initGame(input);		
			var inputLength = input.length;
			var state = STATE_VAR_BEGIN;
			var pos = 0;
			var posVarBegin = 0;
			var posVarEnd = 0;
			var posNode = 0;
			var pointer = 0;
			var isRoot = true;
			var moveNumber = 0;
			var x = -1;
			var y = -1;
			var color = STONE_NONE;
			var setup = false;
			var comment = "";
			var markType = MARK_NONE;
			var markText = "";
			var currentNode = game.rootNode;
			var nodeStack = new Array();

			do {
				//{{{ Check states
				posVarBegin = input.indexOf('(', pointer);
				posVarEnd = input.indexOf(')', pointer);
				posNode = input.indexOf(';', pointer);
		
				pos = this.minPos(posVarBegin, posVarEnd, posNode);
				
				// Switch states
		
				// Node . VarEnd
				if (state == STATE_NODE && pos == posVarEnd)
					state = STATE_VAR_END;
				
				// Node . VarBegin
				if (state == STATE_NODE && pos == posVarBegin)
					state = STATE_VAR_BEGIN;
				
				// VarBegin . Node
				else if (state == STATE_VAR_BEGIN && pos == posNode)
					state = STATE_NODE;
				
				// VarEnd . VarBegin
				else if (state == STATE_VAR_END && pos == posVarBegin)
					state = STATE_VAR_BEGIN;
				//}}}
				
				// Do the work
				switch (state) {
				//{{{ Var begin
				case STATE_VAR_BEGIN:
					if (pos != posVarBegin)
						throw this.createErrorMsg(input, pos);
		
					nodeStack.push(currentNode);
		
					pointer = pos + 1;
					break; //}}}
				//{{{ Var end
				case STATE_VAR_END:
					if (pos != posVarEnd)
						throw this.createErrorMsg(input, pos);
		
					currentNode = nodeStack.pop();
					moveNumber = currentNode.moveNumber;
		
					pointer = pos + 1;
					break; //}}}
				//{{{ Var node
				case STATE_NODE:
					if (pos != posNode)
						throw this.createErrorMsg(input, pos);
	
					if (isRoot) {
						isRoot = false;
					} else {
						if (currentNode.isDummyNode() && currentNode.parent != null){
							// remove it from the tree.
							currentNode.parent.children.pop();
							currentNode = currentNode.parent;
						}
						// Create empty node
						var newNode = new Node(currentNode);
						newNode.moveNumber = moveNumber;
						if (nodeStack.length > 0)
							newNode.depth = nodeStack[nodeStack.length - 1].depth + 1;
						currentNode.children.push(newNode);
						currentNode = newNode;
					}
					var prop;
					pos++;
					do {
						var tmppos = 0;
						pos = this.nextNonSpace(input, pos);
		
						//{{{ Parse properties
						if (input.charAt(pos) == 'B' && input.charAt(tmppos = this.nextNonSpace(input, pos + 1)) == '[') {
							prop = PROPERTY_MOVE_BLACK;
							pos = tmppos;
							color = STONE_BLACK;
						}
						else if (input.charAt(pos) == 'W' && input.charAt(tmppos = this.nextNonSpace(input, pos + 1)) == '[') {
							prop = PROPERTY_MOVE_WHITE;
							pos = tmppos;
							color = STONE_WHITE;
						}
						else if (input.charAt(pos) == 'A' && input.charAt(pos + 1) == 'B' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_BLACK;
							pos = tmppos;
							setup = true;
							color = STONE_BLACK;
						}
						else if (input.charAt(pos) == 'A' && input.charAt(pos + 1) == 'W' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_WHITE;
							pos = tmppos;
							setup = true;
							color = STONE_WHITE;
						}
						else if (input.charAt(pos) == 'A' && input.charAt(pos + 1) == 'E' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_ERASE;
							pos = tmppos;
							setup = true;
							color = STONE_ERASE;
						}
						else if (input.charAt(pos) == 'T' && input.charAt(pos + 1) == 'R' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_MARK;
							markType = MARK_TRIANGLE;
							pos = tmppos;
						}
						else if (input.charAt(pos) == 'C' && input.charAt(pos + 1) == 'R' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_MARK;
							markType = MARK_CIRCLE;
							pos = tmppos;
						}
						else if (input.charAt(pos) == 'S' && input.charAt(pos + 1) == 'Q' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_MARK;
							markType = MARK_SQUARE;
							pos = tmppos;
						}
						else if (input.charAt(pos) == 'M' && input.charAt(pos + 1) == 'A' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_MARK;
							markType = MARK_CROSS;
							pos = tmppos;
						}
						else if (input.charAt(pos) == 'L' && input.charAt(pos + 1) == 'B' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_MARK;
							markType = MARK_TEXT;
							pos = tmppos;
							oldLabel = false;
						}
						else if (input.charAt(pos) == 'C' && input.charAt(tmppos = this.nextNonSpace(input, pos + 1)) == '[') {
							prop = PROPERTY_COMMENT;
							pos = tmppos;
						}
						else if (input.charAt(pos) == 'T' && input.charAt(pos + 1) == 'B' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_MARK;
							markType = MARK_TERR_BLACK;
							pos = tmppos;
							color = STONE_BLACK;
						}
						else if (input.charAt(pos) == 'T' && input.charAt(pos + 1) == 'W' &&
								input.charAt(tmppos = this.nextNonSpace(input, pos + 2)) == '[') {
							prop = PROPERTY_EDIT_MARK;
							markType = MARK_TERR_WHITE;
							pos = tmppos;
							color = STONE_WHITE;
						}
						// Empty node
						else if (input.charAt(pos) == ';' || input.charAt(pos) == '(' || input.charAt(pos) == ')') {
							pos = this.nextNonSpace(input, pos);
		
							continue;
						}
						else {
							var tmp = input.indexOf("]", pos) + 1;
							if (tmp <= 0) {
								pointer = pos + 1;
								break;
							}
							pos = tmp;
							pos = this.nextNonSpace(input, pos);
		
							continue;
						} //}}}
		
						//{{{ Parse values
						// Next is one or more '[xx]'.
						// Only one in a move property, several in a setup propery
						do {
							if (input.charAt(pos) != '[')
								throw this.createErrorMsg(input, pos);
		
							// Empty type
							if (input.charAt(pos + 1) == ']') {
								// CGoban stores pass as 'B[]' or 'W[]'
								if (prop == PROPERTY_MOVE_BLACK || prop == PROPERTY_MOVE_WHITE) {
									currentNode.type = NODE_PASS;
									currentNode.color = color;
									currentNode.moveNumber = ++moveNumber;
								}
								pos += 2;
								continue;
							}
		
							switch (prop) {
							//{{{ MOVE or ADD or ERASE
							case PROPERTY_MOVE_BLACK:
							case PROPERTY_MOVE_WHITE:
								x = input.charCodeAt(pos + 1) - CHAR_A_CODE;
								y = input.charCodeAt(pos + 2) - CHAR_A_CODE;
	
								currentNode.type = NODE_MOVE;
								if (x >= 19 || y >= 19)
									currentNode.type = NODE_PASS;
		
								currentNode.color = color;
								currentNode.x = x;
								currentNode.y = y;
								currentNode.moveNumber = ++moveNumber;
		
								// Advance pos by 4
								pos += 4;
								break;
	
							case PROPERTY_EDIT_BLACK:
							case PROPERTY_EDIT_WHITE:
							case PROPERTY_EDIT_ERASE:
								x = input.charCodeAt(pos + 1) - CHAR_A_CODE;
								y = input.charCodeAt(pos + 2) - CHAR_A_CODE;
								currentNode.points.push(new Point(x, y, color));
								
								// Advance pos by 4
								pos += 4;
								break; //}}}
		
							//{{{ COMMENT
							case PROPERTY_COMMENT:
								if (currentNode.comment == null)
									currentNode.comment = "";
		
								while (input.charAt(++pos) != ']' || (input.charAt(pos - 1) == '\\' && input.charAt(pos) == ']')) {
									if (!(input.charAt(pos) == '\\' && input.charAt(pos + 1) == ']') &&
										!(input.charAt(pos) == '\\' && input.charAt(pos + 1) == '[') &&
										!(input.charAt(pos) == '\\' && input.charAt(pos + 1) == ')') &&
										!(input.charAt(pos) == '\\' && input.charAt(pos + 1) == '('))
										currentNode.comment += input.charAt(pos);
		
									if (pos > inputLength)
										throw this.createErrorMsg(input, inputLength);
								}
		
								pos++;
								break; //}}}

							//{{{ EDIT_MARK
							case PROPERTY_EDIT_MARK:
								while (input.charAt(pos) == '[' && pos < inputLength) {
									x = input.charCodeAt(pos + 1) - CHAR_A_CODE;
									y = input.charCodeAt(pos + 2) - CHAR_A_CODE;
									pos += 3;
									markText = "";
		
									// 'LB' property? Then we need to get the text
									if (markType == MARK_TEXT) {
										if (input.charAt(pos) != ':')
											throw this.createErrorMsg(input, pos);
		
										while (input.charAt(++pos) != ']' && pos < inputLength)
											markText += input.charAt(pos);

										// It might be a number mark?
										try {
											var n = parseInt(markText);
											// Yes, its a number
											markType = MARK_TEXT;
										} catch (e) {
											// Nope, its a letter
											markType = MARK_TEXT;
										}
									}
									
									if (currentNode.marks == null)
										currentNode.marks = new Array();
									currentNode.marks.push([x, y, markType, markText]);
		
									pos++;
									pos = this.nextNonSpace(input, pos);
								}
								break; //}}}
							}
							
							pos = this.nextNonSpace(input, pos);
		
						} while (setup && input.charAt(pos) == '['); //}}}
		
						pos = this.nextNonSpace(input, pos);
		
					} while (input.charAt(pos) != ';' && input.charAt(pos) != '(' && input.charAt(pos) != ')' && pos < inputLength);
					
					pos = this.nextNonSpace(input, pos);
					
					// Advance pointer
					pointer = pos;
					break; //}}}
		
				default:
					throw this.createErrorMsg(input, pointer);
				}
		
			} while(pointer < inputLength && pos >= 0);
	
			if (currentNode.isDummyNode() && currentNode.parent != null){
				// remove it from the tree.
				currentNode.parent.children.pop();
			}
			return game;
		} catch(e) {
			throw this.createErrorMsg(input,pos,e);
		}
	}
}