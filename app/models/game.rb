class Game < ActiveRecord::Base
  belongs_to :gaming_platform
  
  WINNER_BLACK = 1
  WINNER_WHITE = 2

  def black_name_with_rank
    s = self.black_name
    s << "(" << self.black_rank << ")" unless self.black_rank.blank?
    s
  end

  def white_name_with_rank
    s = self.white_name
    s << "(" << self.white_rank << ")" unless self.white_rank.blank?
    s
  end
  
  def load_parsed_game sgf_game
    self.board_size = sgf_game.board_size
    self.handicap = sgf_game.handicap
    self.name = sgf_game.name
    self.black_name = sgf_game.black_player
    self.black_rank = sgf_game.black_rank
    self.white_name = sgf_game.white_player
    self.white_rank = sgf_game.white_rank
    self.played_at_raw = sgf_game.played_on
    self.rule_raw = sgf_game.rule
    self.komi_raw = sgf_game.komi
    self.time_rule = sgf_game.time_rule
    self.result = sgf_game.result
    self.moves = sgf_game.moves
    self.program = sgf_game.program
    self.place = sgf_game.place
    self.event = sgf_game.event
    
    if self.place =~ /www\.gokgs\.com/i
      self.is_online_game = true
      self.gaming_platform = GamingPlatform.kgs
      self.black_id = OnlinePlayer.find_or_create(GamingPlatform.kgs, self.black_name).id
      self.white_id = OnlinePlayer.find_or_create(GamingPlatform.kgs, self.white_name).id
    end
    
    if self.result =~ /B+/i
      self.winner = WINNER_BLACK
    elsif self.result =~ /W+/i
      self.winner = WINNER_WHITE
    end
  end
end
