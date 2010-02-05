module UrlsHelper
  def url_for_uploads_of_today
    url_for(:controller => :upload_search, :action => :index, :op => 'search', :from_date => Date.today)
  end

  def url_for_uploads_of_7_days
    url_for(:controller => :upload_search, :action => :index, :op => 'search', :from_date => Date.today - 6.days)
  end

  def url_for_player player
    if player.is_a? Player
      player_url(player)
    elsif player.is_a? OnlinePlayer
      online_player_url(player)
    else
      raise "Invalid opponent: #{player.inspect}"
    end
  end

  def url_for_pair pair
    if pair.is_a? PairStat
      pair_url(pair)
    elsif pair.is_a? OnlinePairStat
      online_pair_url(pair)
    else
      raise "Invalid opponent: #{pair.inspect}"
    end
  end
end
