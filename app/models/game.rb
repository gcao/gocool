class Game < ActiveRecord::Base
  def load_parsed_game sgf_game
    self.board_size = sgf_game.board_size
    self.handicap = sgf_game.handicap
    self.name = sgf_game.name
    self.black_name = sgf_game.black_player
    self.white_name = sgf_game.white_player
    self.played_at_raw = sgf_game.played_on
    self.rule_raw = sgf_game.rule
    self.komi_raw = sgf_game.komi
    self.time_rule = sgf_game.time_rule
    self.result = sgf_game.result
    self.program = sgf_game.program
  end
end
