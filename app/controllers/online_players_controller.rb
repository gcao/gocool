class OnlinePlayersController < ApplicationController
  def search
    @online_players = OnlinePlayer.search(params[:platform], params[:username], ENV['ROWS_PER_PAGE'].to_i, params[:page])
    render :layout => false
  end
end