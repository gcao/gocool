class GameMove < ActiveRecord::Base
  include SGF::SGFHelper

  OCCUPIED = 1
  SUICIDE  = 2
  BAD_KO   = 3

  belongs_to :parent, :class_name => 'GameMove', :foreign_key => 'parent_id'
  belongs_to :game_detail

  serialize :dead

  named_scope :moves_after, lambda { |move|
    {:conditions => ["game_detail_id = ? and id > ?", move.game_detail_id, move.id]}
  }

  def move_on_board?
    color != Game::NONE
  end

  def children moves = nil
    return @children unless @children.nil?
    
    @children = []
    moves ||= self.class.moves_after(self)
    moves.each do |move|
      if move.parent_id == id
        @children << move
        moves.delete move
      end
    end

    @children.each do |move|
      move.children moves
    end

    @children
  end

  def board
    return @board if @board
    return @board = Board.load(serialized_board) if serialized_board

    init_board
  end

  def process
    return OCCUPIED if parent and parent.board.occupied?(x, y)

    init_board

    return SUICIDE if suicide?
    return BAD_KO if check_ko

    self.serialized_board = board.dump
  end

  def child_that_matches x, y
    children.detect {|move| move.x == x and move.y == y }
  end

  def to_sgf options = {}
    # Guess move by opponent
    return "" if guess_player_id and options[:player_id] and guess_player_id != options[:player_id]

    return children_to_sgf(options) if move_no == 0 and options[:with_children]

    sgf = move_to_sgf(color, x, y)
    sgf << setup_points_to_sgf
    sgf << dead_points_to_sgf
    sgf << "N[#{self.id}]" if options[:with_name]
    sgf << "C[#{I18n.t('games.guess_move_comment')}]" if move_no > 0 and color != 0 and player_id.blank?
    sgf << children_to_sgf(options) if options[:with_children]
    sgf
  end

  def children_to_sgf options = {}
    return "" if children.blank?
    return children.first.to_sgf(options) if children.size == 1

    children.map {|move|
      sgf = move.to_sgf(options)
      sgf.blank? ? "" : "(#{sgf})"
    }.join
  end

  private

  def add_move_to_board
    @board[x][y] = color if color > 0
  end

  def remove_dead_stones
    self.dead = []
    remove_group @board.get_dead_group(x-1, y) if @board.game_type == Game::DAOQI or x > 0
    remove_group @board.get_dead_group(x+1, y) if @board.game_type == Game::DAOQI or x < @board.size - 1
    remove_group @board.get_dead_group(x, y-1) if @board.game_type == Game::DAOQI or y > 0
    remove_group @board.get_dead_group(x, y+1) if @board.game_type == Game::DAOQI or y < @board.size - 1
    remove_group @board.get_dead_group(x, y)
  end

  def remove_group group
    return if group.blank?
    group.each do |x, y|
      dead << [x, y]
      @board[x][y] = Game::NONE
    end
  end

  def dead_points_to_sgf
    return "" if dead.blank?

    "CR" + dead.map{|point| "[#{xy_to_sgf_pos(point[0], point[1])}]"}.join
  end

  def setup_points_to_sgf
    return "" if setup_points.blank?
    
    JSON.parse(setup_points).map {|item|
      op, x, y = *item
      if op == GameDetail::ADD_BLACK_STONE
        "AB[#{xy_to_sgf_pos(x, y)}]"
      else
        ""
      end
    }.join
  end

  def init_board
    if parent
      @board = parent.board.clone
    else
      @board = Board.new(game_detail.game.board_size, game_detail.game.game_type)
    end

    # place move on board
    add_move_to_board
    # remove dead stones after move
    remove_dead_stones

    @board
  end

  def check_ko
    return if dead.blank? or dead.size != 1
    return unless parent
    return if parent.dead.blank? or parent.dead.size != 1

    dead_x, dead_y = *dead[0]
    old_dead_x, old_dead_y = *parent.dead[0]
    
    dead_x == parent.x and dead_y == parent.y and old_dead_x == x and old_dead_y == y
  end

  def suicide?
    dead == [[x, y]]
  end
end
