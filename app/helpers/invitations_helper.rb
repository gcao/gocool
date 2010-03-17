module InvitationsHelper
  def game_type_select
    select "invitation", "game_type",
           [[t('games.weiqi_label'), Game::WEIQI],
            [t('games.daoqi_label'), Game::DAOQI]]
  end

  def start_side_select
    select "invitation", "start_side",
           [[t('invitations.random_start'), 0],
            [t('invitations.inviter_start'), Invitation::INVITER_PLAY_FIRST],
            [t('invitations.invitee_start'), Invitation::INVITEE_PLAY_FIRST]]
  end

  def handicap_select
    select "invitation", "handicap", (0..9).map{|i| [Invitation.handicap_str(i), i]}
  end
end
