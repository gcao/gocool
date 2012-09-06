# coding: utf-8
module CoolGames
  class Game
    include Mongoid::Document
    include Mongoid::Timestamps
    include GameStateMachine
    include GameInPlay
    include ThreadGlobals

    belongs_to :gaming_platform, class_name: 'CoolGames::GamingPlatform'
    belongs_to :black_player   , class_name: 'CoolGames::Player'        , foreign_key: 'black_id'
    belongs_to :white_player   , class_name: 'CoolGames::Player'        , foreign_key: 'white_id'
    belongs_to :invitation     , class_name: 'CoolGames::Invitation'    , inverse_of:  :game
    embeds_one :root           , class_name: 'CoolGames::GameMove'      , autobuild:    true
    embeds_one :last_move      , class_name: 'CoolGames::GameMove'

    field "game_type"         , type: Integer
    field "state"             , type: String
    field "whose_turn"        , type: Integer
    field "formatted_moves"   , type: String
    field "setup_points"      , type: String
    field "rule"              , type: Integer
    field "rule_raw"          , type: String
    field "board_size"        , type: Integer
    field "handicap"          , type: Integer
    field "start_side"        , type: Integer
    field "komi"              , type: Float
    field "komi_raw"          , type: String
    field "result"            , type: String
    field "winner"            , type: Integer
    field "moves"             , type: Integer
    field "win_points"        , type: Float
    field "name"              , type: String
    field "event"             , type: String
    field "place"             , type: String
    field "source"            , type: String
    field "program"           , type: String
    field "played_at"         , type: Date
    field "played_at_raw"     , type: String
    field "time_rule"         , type: String
    field "description"       , type: String
    field "for_rating"        , type: Boolean
    field "black_name"        , type: String
    field "black_rank"        , type: String
    field "black_team"        , type: String
    field "white_name"        , type: String
    field "white_rank"        , type: String
    field "white_team"        , type: String
    field "updated_by"        , type: String

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

    #default_scope :include => [:gaming_platform, :primary_source]

    #scope :with_detail, :include => [:detail]
    #scope :sort_by_last_move_time, :order => "cg_game_details.last_move_time DESC"
    #scope :sort_by_creation_time, :order => "cg_games.created_at DESC"

    scope :paginate, lambda {|params|
      page(params[:page]).per(params[:per_page])
    }

    scope :by_player, lambda {|p|
      #{
      #  :conditions => ["(black_id = ? or white_id = ?)", p.id, p.id]
      #}
      any_of({black_id: p.id}, {white_id: p.id})
    }

    scope :my_turn, lambda {|p|
      #{
      #  :include => :detail,
      #  :conditions => ["(black_id = ? and (cg_games.state in ('white_request_counting', 'counting', 'white_accept_counting') or (cg_games.state in ('new', 'playing') and cg_game_details.whose_turn = ?)))
      #                or (white_id = ? and (cg_games.state in ('black_request_counting', 'counting', 'black_accept_counting') or (cg_games.state in ('new', 'playing') and cg_game_details.whose_turn = ?)))", p.id, BLACK, p.id, WHITE]
      #}
      any_of(where(black_id: p.id). 
               any_of({:state.in => %w[white_request_counting counting white_accept_counting]}, 
                      {:state.in => %w[white_request_counting counting white_accept_counting]}),
             where(white_id: p.id).
               any_of({:state.in => %w[black_request_counting counting black_accept_counting]}, 
                      {:state.in => %w[black_request_counting counting black_accept_counting]}))
    }

    #scope :not_my_turn, lambda {|p|
    #  {
    #    :include => :detail,
    #    :conditions => ["(black_id = ? and (cg_games.state in ('black_request_counting', 'counting', 'black_accept_counting') or (cg_games.state in ('new', 'playing') and cg_game_details.whose_turn = ?)))
    #                  or (white_id = ? and (cg_games.state in ('white_request_counting', 'counting', 'white_accept_counting') or (cg_games.state in ('new', 'playing') and cg_game_details.whose_turn = ?)))", p.id, WHITE, p.id, BLACK]
    #  }
    #}

    scope :finished, where(state: 'finished')
    #scope :finished, lambda {
    #  {
    #    :conditions => ["state = 'finished'"]
    #  }
    #}

    scope :not_finished, where(:state.ne => 'finished')
    #scope :not_finished, lambda {
    #  {
    #    :conditions => ["state != 'finished'"]
    #  }
    #}

    scope :on_platform, lambda { |platform|
      if platform.is_a? GamingPlatform
        #{ :conditions => ["cg_games.gaming_platform_id = ?", platform.id] }
        where(gaming_platform: platform)
      elsif platform.blank?
        #{ :conditions => "cg_games.gaming_platform_id is null" }
        where(gaming_platform: nil)
      elsif platform.to_i == GamingPlatform::ALL
        #{}
        where()
      else
        #{ :conditions => ["cg_games.gaming_platform_id = ?", platform] }
        where(gaming_platform: platform)
      end
    }

    scope :played_by, lambda {|player1, player2|
      raise ArgumentError.new(I18n.t('games.first_player_is_required')) if player1.blank?

      #player1 = player1.strip.gsub('*', '%')

      if player2.blank?
        #{ :conditions => ["black_name like ? or white_name like ?", player1, player1] }
        any_of({:black_name => player1}, {:white_name => player1})
      else
        #player2 = player2.strip.gsub('*', '%')
        #{
        #  :conditions => [
        #    "(black_name like ? and white_name like ?) or (white_name like ? and black_name like ?)",
        #    player1, player2, player1, player2
        #  ]
        #}
        any_of({:black_name => player1, :white_name => player2},
               {:black_name => player2, :white_name => player1})
      end
    }

    scope :played_between, lambda{|player1_id, player2_id|
      raise ArgumentError.new "Player 1 is not set" if player1_id.blank?
      raise ArgumentError.new "Player 2 is not set" if player2_id.blank?

      #{ :conditions => ["(black_id = ? and white_id = ?) or (black_id = ? and white_id = ?)", 
      #  player1_id, player2_id, player2_id, player1_id] }
      any_of({black_id: player1_id, white_id: player2_id},
             {black_id: player2_id, white_id: player1_id})
    }

    #scope :sort_by_players, order_by(:black_name, :white_name)

    #scope :sort_by_last_move_time, order_by(:last_move_time)

    scope :my_turn_by_name, lambda{|name|
      #{
      #  :include => :detail,
      #  :conditions => ["(black_name = ? and (cg_games.state in ('white_request_counting', 'counting', 'white_accept_counting') or (cg_games.state in ('new', 'playing') and cg_game_details.whose_turn = ?)))
      #                or (white_name = ? and (cg_games.state in ('black_request_counting', 'counting', 'black_accept_counting') or (cg_games.state in ('new', 'playing') and cg_game_details.whose_turn = ?)))",
      #                  name, BLACK, name, WHITE]
      #}
      any_of(where(black_name: name).
               any_of({:state.in => %w[white_request_counting counting white_accept_counting]},
                      {:state.in => %w[new playing], whote_turn: BLACK}),
             where(white_name: name).
               any_of({:state.in => %w[black_request_counting counting black_accept_counting]},
                      {:state.in => %w[new playing], whote_turn: WHITE}))

    }

    scope :by_name, lambda{|name|
      #{
      #  :conditions => ["black_name = ? or white_name = ?", name, name]
      #}
      any_of({black_name: name}, {white_name: name})
    }

    after_create do
      root.move_no      = 0
      root.x            = -1
      root.y            = -1
      root.color        = 0
      root.played_at    = Time.now
      root.setup_points = handicaps
      root.save!

      self.last_move = root
      self.formatted_moves = ::CoolGames::Sgf::NodeRenderer.new(:with_name => true).render(root)
      save!
    end

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
      elsif self.place =~ /tom/i
        platform = GamingPlatform.tom
      elsif self.place =~ /eweiqi/i
        platform = GamingPlatform.eweiqi
      elsif self.place =~ /igs/i
        platform = GamingPlatform.igs
      elsif self.place =~ /sina/i
        platform = GamingPlatform.sina
      end

      self.gaming_platform = platform
      self.black_id = Player.find_or_create(platform, self.black_name, self.black_rank).id
      self.white_id = Player.find_or_create(platform, self.white_name, self.white_rank).id

      PairStat.find_or_create(black_id, white_id)
      PairStat.find_or_create(white_id, black_id)

      if self.result =~ /B+/i or (self.result.nil_or.include?('hei') and self.result.nil_or.include?('sheng'))
        self.state = 'finished'
        self.winner = WINNER_BLACK
      elsif self.result =~ /W+/i or (self.result.nil_or.include?('bai') and self.result.nil_or.include?('sheng'))
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
      return unless current_player

      player = if current_user_is_black?
        I18n.t('games.black_name')
      elsif current_user_is_white?
        I18n.t('games.black_name')
      end
      player.nil_or.sub('PLAYER_NAME', current_player.name)
    end

    def from_url?
      primary_source.try(:source_type) == Upload::UPLOAD_URL
    end

    def change_turn
      if whose_turn == Game::WHITE
        self.whose_turn = Game::BLACK
      else
        self.whose_turn = Game::WHITE
      end
    end

    def last_move
      move = root

      while move.children.size > 0
        move = move.children.first
      end

      move
    end

    def guess_moves
      last_move.children
    end

    private

    def handicaps
      points = []
      case handicap
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
end

