module PlayersHelper
  def show_page_header player
    t('players.games_played_by').gsub('PLAYER_NAME', player.full_name)
  end
end
