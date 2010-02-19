class Invitation < ActiveRecord::Base
  include AASM
  
  belongs_to :inviter, :class_name => 'User', :foreign_key => 'inviter_id'
  
  INVITER_PLAY_FIRST = 1
  INVITEE_PLAY_FIRST = 2

  default_scope :order => "created_at DESC"

  named_scope :by_me, lambda {
    if user = Thread.current[:user]
      {:conditions => ["invitations.inviter_id = ?", user.id]}
    else
      {:conditions => ["invitations.inviter_id is null"]}
    end
  }

  named_scope :to_me, lambda {
    if user = Thread.current[:user]
      {:conditions => ["invitations.inviter_id like '%\"?\":%'", user.id]}
    else
      {:conditions => ["invitations.inviter_id is null"]}
    end
  }

  aasm_column :state

  aasm_initial_state :new
  aasm_state :accepted
  aasm_state :rejected
  #aasm_state :changed_by_inviter
  #aasm_state :changed_by_invitee
  aasm_state :canceled
  aasm_state :expired

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
      when INVITEE_PLAY_FIRST then I18n.t('invitations.inviter_start')
      else I18n.t('invitations.random_start')
    end
  end

  def created_by_me?
    Thread.current[:user].id == self.inviter_id
  end
end
