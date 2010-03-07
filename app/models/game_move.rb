class GameMove < ActiveRecord::Base
  include SGF::SGFHelper

  belongs_to :game_detail
  #acts_as_nested_set
  #has_many :children, :class_name => 'GameMove', :foreign_key => 'parent_id', :order => "created_at"

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
end
