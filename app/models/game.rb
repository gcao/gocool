class Game < ActiveRecord::Base
  belongs_to :gaming_platform
  belongs_to :primary_source, :class_name => 'GameSource', :foreign_key => 'primary_upload_id'
  
  WINNER_BLACK = 1
  WINNER_WHITE = 2
  
  named_scope :by_online_player, lambda {|p|
    {
       :conditions => ["gaming_platform_id = ? and (black_id = ? or white_id = ?)", p.gaming_platform_id, p.id, p.id]
    }
  }

  named_scope :by_player, lambda {|p|
    {
       :conditions => ["gaming_platform_id is null and (black_id = ? or white_id = ?)", p.id, p.id]
    }
  }

  named_scope :on_platform, lambda { |platform_name|
    if platform_name.blank?
      { :conditions => "gaming_platform_id is null" }
    elsif platform_name and platform = GamingPlatform.find_by_name(platform_name)
      { :conditions => ["gaming_platform_id = ?", platform.id] }
    else
      raise "Platform name is not correct: '#{platform_name}'"
    end
  }

  named_scope :played_by, lambda {|player1, player2|
    raise ArgumentError.new(I18n.t('games.first_player_is_required')) if player1.blank?

    player1 = player1.strip.gsub('*', '%')

    if player2.blank?
      { :conditions => ["black_name like ? or white_name like ?", player1, player1] }
    else
      player2 = player2.strip.gsub('*', '%')
      {
        :conditions => [
          "(black_name like ? and white_name like ?) or (white_name like ? and black_name like ?)",
          player1, player2, player1, player2
        ]
      }
    end
  }

  named_scope :played_between, lambda{|player1_id, player2_id|
    raise ArgumentError.new "Player 1 is not set" if player1_id.blank?
    raise ArgumentError.new "Player 2 is not set" if player2_id.blank?

    { :conditions => ["(black_id = ? and white_id = ?) or (black_id = ? and white_id = ?)", player1_id, player2_id, player2_id, player1_id]}
  }

  named_scope :sort_by_players, :order => "black_name, white_name"

  def self.kgs
    gaming_platform_id_is(GamingPlatform.kgs.id)
  end

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
    self.board_size     = sgf_game.board_size
    self.handicap       = sgf_game.handicap
    self.name           = sgf_game.name
    self.black_name     = sgf_game.black_player
    self.black_rank     = sgf_game.black_rank
    self.white_name     = sgf_game.white_player
    self.white_rank     = sgf_game.white_rank
    self.played_at_raw  = sgf_game.played_on
    self.rule_raw       = sgf_game.rule
    self.komi_raw       = sgf_game.komi
    self.time_rule      = sgf_game.time_rule
    self.result         = sgf_game.result
    self.moves          = sgf_game.moves
    self.program        = sgf_game.program
    self.place          = sgf_game.place
    self.event          = sgf_game.event
    
    unless process_online_game
      process_non_online_game
    end
    
    if self.result =~ /B+/i or self.result.try(:include?, '黑胜')
      self.winner = WINNER_BLACK
    elsif self.result =~ /W+/i or self.result.try(:include?, '白胜')
      self.winner = WINNER_WHITE
    end
  end

  def process_online_game
    if self.place =~ /kgs/i
      platform = GamingPlatform.kgs
    elsif self.place =~ /dragongoserver/i
      platform = GamingPlatform.dgs
    else
      return
    end

    self.is_online_game = true
    self.gaming_platform = platform
    self.black_id = OnlinePlayer.find_or_create(platform, self.black_name, self.black_rank).id
    self.white_id = OnlinePlayer.find_or_create(platform, self.white_name, self.white_rank).id

    OnlinePairStat.find_or_create(black_id, white_id)
    OnlinePairStat.find_or_create(white_id, black_id)
    true
  end

  def process_non_online_game
    self.black_id = Player.find_or_create(self.black_name, self.black_rank).id
    self.white_id = Player.find_or_create(self.white_name, self.white_rank).id

    PairStat.find_or_create(black_id, white_id)
    PairStat.find_or_create(white_id, black_id)
  end
  
  def self.search platform_name, player1, player2
    self.on_platform(platform_name).played_by(player1, player2).sort_by_players
  end

  def handicap_str
    self.handicap <= 0 ? "" : self.handicap.to_s
  end

  def komi_str
    self.komi.blank? ? self.komi_raw : self.komi
  end
end
