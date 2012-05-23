# coding: utf-8
class Game < ActiveRecord::Base
  include GameStateMachine
  include GameInPlay
  include ThreadGlobals

  belongs_to :gaming_platform
  belongs_to :primary_source, :class_name => 'Upload', :foreign_key => 'primary_upload_id', :dependent => :destroy
  belongs_to :black_player, :class_name => 'Player', :foreign_key => 'black_id'
  belongs_to :white_player, :class_name => 'Player', :foreign_key => 'white_id'

  has_one :detail, :class_name => 'GameDetail', :dependent => :destroy

  WEIQI = 1
  DAOQI = 2

  NONE  = 0
  BLACK = 1
  WHITE = 2
  ERASE = 3

  WINNER_BLACK = 1
  WINNER_WHITE = 2

  CHINESE_RULE  = 1
  JAPANESE_RULE = 2
  KOREAN_RULE   = 3
  YING_RULE     = 4

  ADD_BLACK_STONE = 1
  ADD_WHITE_STONE = 2

  default_scope :include => [:gaming_platform, :primary_source]

  scope :with_detail, :include => [:detail]
  scope :sort_by_last_move_time, :order => "game_details.last_move_time DESC"

  scope :by_player, lambda {|p|
    {
      :conditions => ["(black_id = ? or white_id = ?)", p.id, p.id]
    }
  }

  scope :my_turn, lambda {|p|
    {
      :include => :detail,
      :conditions => ["(black_id = ? and (games.state in ('white_request_counting', 'counting', 'white_accept_counting') or (games.state in ('new', 'playing') and game_details.whose_turn = ?)))
                    or (white_id = ? and (games.state in ('black_request_counting', 'counting', 'black_accept_counting') or (games.state in ('new', 'playing') and game_details.whose_turn = ?)))", p.id, BLACK, p.id, WHITE]
    }
  }

  scope :not_my_turn, lambda {|p|
    {
      :include => :detail,
      :conditions => ["(black_id = ? and (games.state in ('black_request_counting', 'counting', 'black_accept_counting') or (games.state in ('new', 'playing') and game_details.whose_turn = ?)))
                    or (white_id = ? and (games.state in ('white_request_counting', 'counting', 'white_accept_counting') or (games.state in ('new', 'playing') and game_details.whose_turn = ?)))", p.id, WHITE, p.id, BLACK]
    }
  }

  scope :finished, lambda {
    {
      :conditions => ["state = 'finished'"]
    }
  }

  scope :not_finished, lambda {
    {
      :conditions => ["state != 'finished'"]
    }
  }

  scope :on_platform, lambda { |platform|
    if platform.is_a? GamingPlatform
      { :conditions => ["games.gaming_platform_id = ?", platform.id] }
    elsif platform.blank?
      { :conditions => "games.gaming_platform_id is null" }
    elsif platform.to_i == GamingPlatform::ALL
      {}
    else
      { :conditions => ["games.gaming_platform_id = ?", platform] }
    end
  }

  scope :played_by, lambda {|player1, player2|
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

  scope :played_between, lambda{|player1_id, player2_id|
    raise ArgumentError.new "Player 1 is not set" if player1_id.blank?
    raise ArgumentError.new "Player 2 is not set" if player2_id.blank?

    { :conditions => ["(black_id = ? and white_id = ?) or (black_id = ? and white_id = ?)", player1_id, player2_id, player2_id, player1_id]}
  }

  scope :sort_by_players, :order => "black_name, white_name"

  scope :sort_by_last_move_time, :include => :detail, :order => "game_details.last_move_time"

  scope :my_turn_by_name, lambda{|name|
    {
      :include => :detail,
      :conditions => ["(black_name = ? and (games.state in ('white_request_counting', 'counting', 'white_accept_counting') or (games.state in ('new', 'playing') and game_details.whose_turn = ?)))
                    or (white_name = ? and (games.state in ('black_request_counting', 'counting', 'black_accept_counting') or (games.state in ('new', 'playing') and game_details.whose_turn = ?)))",
                      name, BLACK, name, WHITE] 
    }
  }

  scope :by_name, lambda{|name|
    {
      :conditions => ["black_name = ? or white_name = ?", name, name]
    }
  }

  def daoqi?
    game_type == DAOQI
  end

  def game_type_str
    case game_type
      when DAOQI then I18n.t('games.daoqi_label')
      else I18n.t('games.weiqi_label')
    end
  end

  def black_plays_first?
    not white_plays_first?
  end

  def white_plays_first?
    start_side == WHITE
  end

  def is_online_game?
    not gaming_platform_id.blank?
  end

  def black_name_with_rank
    s = self.black_name || ""
    s << "(" << self.black_rank << ")" unless self.black_rank.blank?
    s
  end

  def white_name_with_rank
    s = self.white_name || ""
    s << "(" << self.white_rank << ")" unless self.white_rank.blank?
    s
  end
  
  def load_parsed_game sgf_game
    self.board_size     = sgf_game.board_size
    self.handicap       = sgf_game.handicap
    self.name           = sgf_game.name
    self.black_name     = sgf_game.black_player.blank? ? "Unknown" : sgf_game.black_player
    self.black_rank     = sgf_game.black_rank
    self.black_team     = sgf_game.black_team
    self.white_name     = sgf_game.white_player.blank? ? "Unknown" : sgf_game.white_player
    self.white_rank     = sgf_game.white_rank
    self.white_team     = sgf_game.white_team
    self.played_at_raw  = sgf_game.played_on
    self.rule_raw       = sgf_game.rule
    self.komi_raw       = sgf_game.komi
    self.time_rule      = sgf_game.time_rule
    self.result         = sgf_game.result
    self.moves          = sgf_game.moves
    self.program        = sgf_game.program
    self.place          = sgf_game.place
    self.event          = sgf_game.event
    self.description    = sgf_game.comment

    if self.place =~ /kgs/i
      platform = GamingPlatform.kgs
    elsif self.place =~ /dragongoserver/i
      platform = GamingPlatform.dgs
    elsif self.place =~ /tom对弈/i
      platform = GamingPlatform.tom
    elsif self.place =~ /弈城/i
      platform = GamingPlatform.eweiqi
    elsif self.place =~ /igs/i
      platform = GamingPlatform.igs
    elsif self.place =~ /新浪/i
      platform = GamingPlatform.sina
    end

    self.gaming_platform = platform
    self.black_id = Player.find_or_create(platform, self.black_name, self.black_rank).id
    self.white_id = Player.find_or_create(platform, self.white_name, self.white_rank).id

    PairStat.find_or_create(black_id, white_id)
    PairStat.find_or_create(white_id, black_id)
    
    if self.result =~ /B+/i or (self.result.try(:include?, '黑') and self.result.try(:include?, '胜'))
      self.state = 'finished'
      self.winner = WINNER_BLACK
    elsif self.result =~ /W+/i or (self.result.try(:include?, '白') and self.result.try(:include?, '胜'))
      self.state = 'finished'
      self.winner = WINNER_WHITE
    end
  end
  
  def self.search platform, player1, player2
    self.on_platform(platform).played_by(player1, player2).sort_by_players
  end

  def handicap_str
    self.handicap.to_i <= 0 ? "" : self.handicap.to_s
  end

  def komi_str
    self.komi.blank? ? self.komi_raw : self.komi
  end

  def winner_str
    if winner == WINNER_BLACK
      I18n.t('games_widget.winner_black')
    elsif winner == WINNER_WHITE
      I18n.t('games_widget.winner_white')
    end
  end

  def rule_str
    case rule
      when CHINESE_RULE then I18n.t('games.chinese_rule')
      when JAPANESE_RULE then I18n.t('games.japanese_rule')
      when KOREAN_RULE then I18n.t('games.korean_rule')
      when YING_RULE then I18n.t('games.ying_rule')
      else ""
    end
  end

  def current_player_str
    player = if current_user_is_black?
      I18n.t('games.black_name')
    elsif current_user_is_white?
      I18n.t('games.black_name')
    end
    player.nil_or.sub('PLAYER_NAME', current_user.email)
  end
  
  def from_url?
    primary_source.try(:source_type) == Upload::UPLOAD_URL
  end
end
