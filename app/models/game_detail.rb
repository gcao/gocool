class GameDetail < ActiveRecord::Base
  include SGF::SGFHelper

  belongs_to :game
  belongs_to :first_move, :class_name => 'GameMove', :foreign_key => 'first_move_id'
  belongs_to :last_move,  :class_name => 'GameMove', :foreign_key => 'last_move_id'

  has_many :all_moves, :class_name => 'GameMove', :dependent => :destroy

  def after_create
    move = GameMove.create!(:game_detail_id => id, :move_no => 0, :x => 0, :y => 0, :color => 0, :played_at => Time.now)
    self.first_move_id = self.last_move_id = move.id
    save!
  end

  def change_turn
    if whose_turn == Game::WHITE
      self.whose_turn = Game::BLACK
    else
      self.whose_turn = Game::WHITE
    end
  end

  def guess_moves
    last_move.children
  end

  def guess_moves_to_sgf
    guess_moves.map{|move|
      sgf = move.to_sgf(:with_name => true, :with_children => true, :player_id => game.current_player.id)
      sgf.blank? ? "" : "(#{sgf})"
    }.join
  end

  def moves_to_sgf
    if game.current_user_is_player?
      sgf = formatted_moves.to_s
      sgf << guess_moves_to_sgf
      sgf
    else
      formatted_moves.to_s
    end
  end
end
