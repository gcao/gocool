class PlayersController < ApplicationController
  def index
  end
  
  def search_online_players
    @online_players = OnlinePlayer.search(params[:platform], params[:username])
    render :layout => false
  end
end