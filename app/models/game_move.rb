class GameMove < ActiveRecord::Base
  include SGF::SGFHelper

  belongs_to :parent, :class_name => 'GameMove', :foreign_key => 'parent_id'
  belongs_to :game_detail

  named_scope :moves_after, lambda { |move|
    {:conditions => ["game_detail_id = ? and id > ?", move.game_detail_id, move.id]}
  }

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

  def child_that_matches x, y
    children.detect {|move| move.x == x and move.y == y }
  end

  def to_sgf options = {}
    # Guess move by opponent
    return "" if guess_player_id and options[:player_id] and guess_player_id != options[:player_id]

    return children_to_sgf(options) if move_no == 0 and options[:with_children]

    sgf = move_to_sgf(color, x, y)
    sgf << "N[#{self.id}]" if options[:with_name]
    sgf << "C[#{I18n.t('games.guess_move_comment')}]" if player_id.blank?
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
    remove_group @board.get_dead_group(x-1, y) if x > 0
    remove_group @board.get_dead_group(x+1, y) if x < @board.size - 1
    remove_group @board.get_dead_group(x, y-1) if y > 0
    remove_group @board.get_dead_group(x, y+1) if y < @board.size - 1
    remove_group @board.get_dead_group(x, y)
  end

  def remove_group group
    return if group.blank?
    group.each do |x, y|
      @board[x][y] = Game::NONE
    end
  end
end
