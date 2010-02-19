class Invitation < ActiveRecord::Base
  belongs_to :inviter, :class_name => 'User', :foreign_key => 'inviter_id'

  INVITER_PLAY_FIRST = 1
  INVITEE_PLAY_FIRST = 2

  named_scope :mine, lambda {
    if user = Thread.current[:user]
      {:conditions => ["invitations.inviter_id = ? or invitations.inviter_id like '%\"?\":%'", user.id, user.id]}
    else
      {:conditions => ["invitations.inviter_id is null"]}
    end
  }

  def self.parse_invitees invitees
    unrecognized = []
    result = {}
    invitees.split(/ ,/).each do |invitee|
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
end
