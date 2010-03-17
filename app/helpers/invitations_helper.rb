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
    select "invitation", "handicap",
           [[t('invitations.handicap_0'), 0],
            [t('invitations.handicap_1'), 1],
            [t('invitations.handicap_2'), 2],
            [t('invitations.handicap_3'), 3],
            [t('invitations.handicap_4'), 4],
            [t('invitations.handicap_5'), 5],
            [t('invitations.handicap_6'), 6],
            [t('invitations.handicap_7'), 7],
            [t('invitations.handicap_8'), 8],
            [t('invitations.handicap_9'), 9]]
  end
end
