class GameDetail < ActiveRecord::Base
  include SGF::SGFHelper

  belongs_to :game
  belongs_to :first_move, :class_name => 'GameMove', :foreign_key => 'first_move_id'
  belongs_to :last_move,  :class_name => 'GameMove', :foreign_key => 'last_move_id'

  def change_turn
    if whose_turn == Game::WHITE
      self.whose_turn = Game::BLACK
    else
      self.whose_turn = Game::WHITE
    end
  end
end
