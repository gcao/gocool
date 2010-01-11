module OnlinePlayersHelper
  def show_page_header online_player
    t('players.games_played_by').
            gsub('PLATFORM_NAME', online_player.gaming_platform.name).
            gsub('PLAYER_NAME', online_player.username)
  end
end
