class OnlinePlayersController < ApplicationController
  def search
    @online_players = OnlinePlayer.search(params[:platform], params[:username])
    render :layout => false
  end
end