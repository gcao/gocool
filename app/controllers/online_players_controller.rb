class OnlinePlayersController < ApplicationController
  def show
    @online_player = OnlinePlayer.find params[:id]
    @games = Game.by_online_player(@online_player)
  end
  
  def search
    @online_players = OnlinePlayer.search(params[:platform], params[:username], ENV['ROWS_PER_PAGE'].to_i, params[:page])
    render :layout => false
  end
end