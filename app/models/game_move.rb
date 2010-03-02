class GameMove < ActiveRecord::Base
  belongs_to :game_detail
  acts_as_nested_set

  def child_that_matches x, y
    children.detect {|move| move.x == x and move.y == y }
  end
end
