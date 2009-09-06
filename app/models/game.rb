class Game < ActiveRecord::Base
  def load_parsed_game sgf_game
    self.name = sgf_game.name
    self.black_name = sgf_game.black_player
    self.white_name = sgf_game.white_player
  end
end
