class GameDetail < ActiveRecord::Base
  include SGF::SGFHelper

  belongs_to :game
  belongs_to :first_move, :class_name => 'GameMove', :foreign_key => 'first_move_id'
  belongs_to :last_move,  :class_name => 'GameMove', :foreign_key => 'last_move_id'

  def add_move x, y
    self.last_move_time = Time.now
    self.formatted_moves = "#{formatted_moves}#{move_to_sgf(whose_turn, x, y)}"
    self.whose_turn = whose_turn == Game::WHITE ? Game::BLACK : Game::WHITE
  end
end
