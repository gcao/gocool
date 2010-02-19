module InvitationsHelper
  def start_side_select
    select "invitation", "start_side",
           [[t('invitations.random_start'), 0],
            [t('invitations.inviter_start'), Invitation::INVITER_PLAY_FIRST],
            [t('invitations.invitee_start'), Invitation::INVITEE_PLAY_FIRST]]
  end
end