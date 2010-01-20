class OnlinePlayersController < ApplicationController
  def show
    @online_player = OnlinePlayer.find params[:id]
    @games = Game.by_online_player(@online_player).paginate(page_params)

    @games_total = @online_player.stat.games
    @games_won = @online_player.stat.games_won
    @games_lost = @online_player.stat.games_lost

    @opponents = @online_player.opponents
  end
  
  def search
    @online_players = OnlinePlayer.search(params[:platform], params[:username]).paginate(page_params)
    render :layout => false
  end
end
