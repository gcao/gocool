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

  def moves_to_sgf
    return "" if game.moves == 0

    if game.current_user_is_player?
      sgf = formatted_moves
      sgf << last_move.children_to_sgf(:with_name => true, :with_children => true, :player_id => game.current_player.id)
      sgf
    else
      formatted_moves.to_s
    end
  end
end
