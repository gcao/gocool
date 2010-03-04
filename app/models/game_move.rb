class GameMove < ActiveRecord::Base
  include SGF::SGFHelper

  belongs_to :game_detail
  acts_as_nested_set

  def child_that_matches x, y
    children.detect {|move| move.x == x and move.y == y }
  end

  def to_sgf options = {}
    # Guess move by opponent
    return "" if guess_player_id and options[:player_id] and guess_player_id != options[:player_id]
    
    sgf = move_to_sgf(color, x, y)
    sgf << "N[#{self.id}]" if options[:with_name]
    sgf << children_to_sgf(options) if options[:with_children]
    sgf
  end

  def children_to_sgf options = {}
    return "" if children.blank?
    return children.first.to_sgf(options) if children.size == 1

    children.map {|move|
      "(#{move.to_sgf(options)})"
    }.join
  end
end
