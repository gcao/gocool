class Invitation < ActiveRecord::Base
  include ThreadGlobals
  include AASM
  
  belongs_to :inviter, :class_name => 'User', :foreign_key => 'inviter_id'
  belongs_to :game
  
  INVITER_PLAY_FIRST = 1
  INVITEE_PLAY_FIRST = 2

  default_scope :order => "created_at DESC",
                :conditions => ["invitations.state not in ('accepted', 'rejected', 'canceled', 'expired')"]

  named_scope :by_me, lambda {
    if user = current_user
      {:conditions => ["invitations.inviter_id = ?", user.id]}
    else
      {:conditions => ["invitations.inviter_id is null"]}
    end
  }

  named_scope :to_me, lambda {
    if user = current_user
      {:conditions => ["invitations.invitees like ?", "%\"#{user.id}\":%"]}
    else
      {:conditions => ["invitations.invitees is null"]}
    end
  }

  aasm_column :state

  aasm_initial_state :new

  aasm_state :new
  aasm_state :accepted, :enter => :create_game
  aasm_state :rejected
  #aasm_state :changed_by_inviter
  #aasm_state :changed_by_invitee
  aasm_state :canceled
  aasm_state :expired

  aasm_event :accept do
    transitions :to => :accepted, :from => [:new]
  end

  aasm_event :reject do
    transitions :to => :rejected, :from => [:new]
  end

  aasm_event :cancel do
    transitions :to => :canceled, :from => [:new]
  end

  def self.parse_invitees invitees
    unrecognized = []
    result = {}
    invitees.split(/[ ,]+/).each do |invitee|
      invitee.strip!
      begin
        user = User.find_or_load invitee
        result[user.id] = invitee
      rescue ActiveRecord::RecordNotFound
        unrecognized << invitee
      end
    end
    return result, unrecognized
  end

  def invitees_str
    unless invitees.blank?
      JSON.parse(invitees).values.join(", ")
    end
  end

  def start_side_str
    case start_side
      when INVITER_PLAY_FIRST then I18n.t('invitations.inviter_start')
      when INVITEE_PLAY_FIRST then I18n.t('invitations.invitee_start')
      else I18n.t('invitations.random_start')
    end
  end

  def created_by_me?
    current_user.id == self.inviter_id
  end

  def create_game
    game = Game.new
    game.gaming_platform_id = GamingPlatform.qiren.id
    game.game_type = game_type
    game.rule = rule
    game.handicap = handicap
    game.komi = komi
    game.name = note
    game.start_side = start_side
    game.for_rating = for_rating
    game.place = "#{GamingPlatform.qiren.name} #{GamingPlatform.qiren.url}"

    invitee = current_user
    if start_side == INVITER_PLAY_FIRST or (start_side != INVITEE_PLAY_FIRST and rand(1000)%2 == 0) # inviter plays first
      game.black_id = inviter.qiren_player.id
      game.black_name = inviter.qiren_player.name
      game.black_rank = inviter.qiren_player.rank
      game.white_id = invitee.qiren_player.id
      game.white_name = invitee.qiren_player.name
      game.white_rank = invitee.qiren_player.rank
    else # invitee plays first
      game.black_id = invitee.qiren_player.id
      game.black_name = invitee.qiren_player.name
      game.black_rank = invitee.qiren_player.rank
      game.white_id = inviter.qiren_player.id
      game.white_name = inviter.qiren_player.name
      game.white_rank = inviter.qiren_player.rank
    end
    game.start
    game.save!

    self.game_id = game.id
    self.save!

    GameDetail.create!(:game_id => game.id)
    game
  end
end
