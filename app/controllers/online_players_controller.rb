class OnlinePlayersController < ApplicationController
  def show
    @player = OnlinePlayer.find params[:id]
    @games = Game.by_online_player(@player).paginate(page_params)

    @games_total = @player.stat.games
    @games_won = @player.stat.games_won
    @games_lost = @player.stat.games_lost

    @opponents = @player.opponents
  end
end
