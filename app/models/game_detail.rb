class GameDetail < ActiveRecord::Base
  include SGF::SGFHelper

  belongs_to :game

  def add_move x, y
    self.last_move_time = Time.now
    self.formatted_moves = "#{formatted_moves}#{move_to_sgf(whose_turn, x, y)}"
    self.whose_turn = whose_turn == Game::WHITE ? Game::BLACK : Game::WHITE
  end
end
