module PairsHelper
  def player_opponent_html player, opponent
    "#{player.name} : #{opponent.name}"
  end
end
