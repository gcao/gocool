module CoolGames
  class Invitation
    include Mongoid::Document
    include Mongoid::Timestamps
    include AASM
    include ThreadGlobals

    INVITER_PLAY_FIRST = 1
    INVITEE_PLAY_FIRST = 2

    belongs_to :inviter, class_name: 'CoolGames::Player'
    belongs_to :invitee, class_name: 'CoolGames::Player'
    has_one    :game   , class_name: 'CoolGames::Game'  , inverse_of: :invitation

    field "game_type" , type: Integer, default: Game::WEIQI
    field "state"     , type: String , default: 'new'
    field "rule"      , type: Integer, default: 1
    field "handicap"  , type: Integer
    field "start_side", type: Integer, default: INVITER_PLAY_FIRST
    field "komi"      , type: Float  , default: 7.5
    field "for_rating", type: Boolean
    field "note"      , type: String
    field "response"  , type: String
    field "expires_on", type: Date

    default_scope order_by([[:created_at, :desc]])

    scope :active, where(:state.nin => %w[accepted rejected canceled expired])

    scope :of_player, lambda { |player|
      any_of({inviter_id: player.id}, {invitee_id: player.id})
    }

    scope :by_me, lambda { |player|
      #{:conditions => ["inviter_id = ?", player.id]}
      where(inviter_id: player.id)
    }

    scope :to_me, lambda { |player|
      #{:conditions => ["invitees like ?", "%\"#{player.id}\":%"]}
      where(invitee_id: player.id)
    }

    aasm_column :state

    aasm_initial_state :new

    aasm_state :new
    aasm_state :accepted, :enter => :create_game
    aasm_state :rejected, :enter => :send_reject_message
    aasm_state :changed_by_inviter
    aasm_state :changed_by_invitee
    aasm_state :canceled
    aasm_state :expired

    aasm_event :accept do
      transitions :to => :accepted, :from => [:new, :changed_by_inviter], :guard => :current_player_is_invitee?
      transitions :to => :accepted, :from => [:changed_by_invitee      ], :guard => :current_player_is_inviter?
    end

    aasm_event :reject do
      transitions :to => :rejected, :from => [:new, :changed_by_inviter], :guard => :current_player_is_invitee?
      transitions :to => :rejected, :from => [:changed_by_invitee      ], :guard => :current_player_is_inviter?
    end

    aasm_event :cancel do
      transitions :to => :canceled, :from => [:new, :changed_by_inviter], :guard => :current_player_is_inviter?
      transitions :to => :canceled, :from => [:changed_by_invitee      ], :guard => :current_player_is_invitee?
    end

    aasm_event :change do
      transitions :to => :changed_by_inviter, :from => [:new, :changed_by_invitee], :guard => :current_player_is_inviter?
      transitions :to => :changed_by_invitee, :from => [:new, :changed_by_inviter], :guard => :current_player_is_invitee?
    end

    def self.parse_invitees invitees
      unrecognized = []
      result       = []

      invitees.split(/[ ,]+/).each do |invitee|
        invitee.strip!

        begin
          if player = Player.find_by(name: invitee)
            result << player
          else
            unrecognized << invitee
          end
        rescue Mongoid::Errors::DocumentNotFound
          unrecognized << invitee
        end
      end

      return result, unrecognized
    end

    def self.handicap_str handicap
      I18n.t("invitations.handicap_#{handicap}")
    end

    after_create do
      send_invitation_message
    end

    def current_player_is_inviter?
      logged_in? and current_player.id == inviter_id
    end

    def current_player_is_invitee?
      logged_in? and current_player.id == invitee_id
    end

    def game_type_str
      case game_type
        when CoolGames::Game::DAOQI then I18n.t('games.daoqi_label')
        else I18n.t('games.weiqi_label')
      end
    end

    def start_side_str
      case start_side
        when INVITER_PLAY_FIRST then I18n.t('invitations.inviter_start')
        when INVITEE_PLAY_FIRST then I18n.t('invitations.invitee_start')
        else I18n.t('invitations.random_start')
      end
    end

    def handicap_str
      self.class.handicap_str(handicap.to_i)
    end

    def created_by_me? player
      player.id == self.inviter_id
    end

    def for_me? player
      invitee == player
    end

    def create_game
      game                    = Game.new
      game.state              = 'new'
      game.gaming_platform_id = GamingPlatform.gocool.id
      game.game_type          = game_type
      game.board_size         = 19
      game.rule               = rule
      game.handicap           = handicap
      game.komi               = komi
      game.name               = note
      game.moves              = 0
      game.start_side         = handicap.to_i < 2 ? Game::BLACK : Game::WHITE
      game.for_rating         = for_rating
      game.place              = "#{GamingPlatform.gocool.name} #{GamingPlatform.gocool.url}"

      #PairStat.find_or_create(inviter.id, invitee.id)
      #PairStat.find_or_create(invitee.id, inviter.id)

      if start_side == INVITER_PLAY_FIRST or (start_side != INVITEE_PLAY_FIRST and rand(1000)%2 == 0) # inviter plays first
        game.black_id   = inviter.id
        game.black_name = inviter.name
        game.black_rank = inviter.rank
        game.white_id   = invitee.id
        game.white_name = invitee.name
        game.white_rank = invitee.rank
      else # invitee plays first
        game.black_id   = invitee.id
        game.black_name = invitee.name
        game.black_rank = invitee.rank
        game.white_id   = inviter.id
        game.white_name = inviter.name
        game.white_rank = inviter.rank
      end
      game.start
      game.save!

      self.game = game
      self.save!

      #GameDetail.create!(:game_id => game.id, :whose_turn => game.start_side, :formatted_moves => "")

      #Discuz::PrivateMessage.send_message invitee, inviter, "",
      #                                    I18n.t('invitations.accept_invitation_body').sub('USERNAME', invitee.name).sub("GAME_URL", "#{ENV['BASE_URL']}/app/games/#{game.id}")

      game
    end

    def send_reject_message
      #invitee = current_player
      #Discuz::PrivateMessage.send_message invitee, inviter, "",
      #                                    I18n.t('invitations.reject_invitation_body').sub('USERNAME', invitee.name).sub("INVITATION_URL", "#{ENV['BASE_URL']}/app/invitations/#{id}")
    end

    def send_invitation_message
      #JSON.parse(invitees).keys.each do |invitee_id|
      #  invitee = Player.find invitee_id
      #  Discuz::PrivateMessage.send_message inviter, invitee, "",
      #                                      I18n.t('invitations.invitation_body').sub('USERNAME', inviter.name).
      #                                              gsub("INVITATION_URL", "#{ENV['BASE_URL']}/app/invitations/#{id}").
      #                                              sub('GAME_TYPE', game_type_str)
      #end
    end

    def as_json options = {}
      result = super(options)
      result[:id            ] = _id
      result[:game_type_str ] = game_type_str
      result[:handicap_str  ] = handicap_str
      result[:start_side_str] = start_side_str
      result[:inviter       ] = inviter
      result[:invitee       ] = invitee
      result[:game_id       ] = game.id if game
      result[:is_inviter    ] = current_player_is_inviter?
      result[:is_invitee    ] = current_player_is_invitee?
      result
    end
  end
end
