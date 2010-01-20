module PlayersHelper
  def show_page_header player
    t('players.games_played_by').gsub('PLAYER_NAME', player.full_name)
  end

  def url_for_opponent opponent
    if opponent.is_a? Player
      player_url(opponent)
    elsif opponent.is_a? OnlinePlayer
      online_player_url(opponent)
    else
      raise "Invalid opponent: #{opponent.inspect}"
    end
  end
end
