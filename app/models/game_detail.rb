class GameDetail < ActiveRecord::Base
  include SGF::SGFHelper

  ADD_BLACK_STONE = 1
  ADD_WHITE_STONE = 2

  belongs_to :game
  belongs_to :first_move, :class_name => 'GameMove', :foreign_key => 'first_move_id'
  belongs_to :last_move,  :class_name => 'GameMove', :foreign_key => 'last_move_id'

  has_many :all_moves, :class_name => 'GameMove', :dependent => :destroy

  def after_create
    move = GameMove.create!(:game_detail_id => id,
                            :move_no => 0, :x => -1, :y => -1, :color => 0, :played_at => Time.now,
                            :setup_points => handicaps)
    self.formatted_moves = move.to_sgf(:with_name => true)
    self.first_move_id = self.last_move_id = move.id
    self.last_move_time = Time.now
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

  private

  def handicaps
    points = []
    case game.handicap
      when 2 then points << [3, 3] << [15, 15]
      when 3 then points << [3, 3] << [15, 15] << [3, 15]
      when 4 then points << [3, 3] << [15, 15] << [3, 15] << [15, 3]
      when 5 then points << [3, 3] << [15, 15] << [3, 15] << [15, 3] << [9, 9]
      when 6 then points << [3, 3] << [15, 15] << [3, 15] << [15, 3] << [3, 9] << [15, 9]
      when 7 then points << [3, 3] << [15, 15] << [3, 15] << [15, 3] << [3, 9] << [15, 9] << [9, 9]
      when 8 then points << [3, 3] << [15, 15] << [3, 15] << [15, 3] << [3, 9] << [15, 9] << [9, 3] << [9, 15]
      when 9 then points << [3, 3] << [15, 15] << [3, 15] << [15, 3] << [3, 9] << [15, 9] << [9, 3] << [9, 15] << [9, 9]
    end
    points.map{|point| [ADD_BLACK_STONE, point[0], point[1]]}.to_json
  end
end
