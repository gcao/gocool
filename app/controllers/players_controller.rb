class PlayersController < ApplicationController
  def index
  end

  def show
    @player = Player.find params[:id]
    @games = Game.by_player(@player).paginate(page_params)

    @games_total = @player.stat.games
    @games_won = @player.stat.games_won
    @games_lost = @player.stat.games_lost

    @opponents = @player.opponents
  end

  def search
    @platform = params[:platform]
    @name = params[:name]
    if @platform.blank?
      @players = Player.name_like(@name).with_stat.paginate(page_params)
      render :partial => "players", :layout => false
    elsif @platform.strip == 'all'
      # TODO
    else
      @players = OnlinePlayer.search(@platform, @name).paginate(page_params)
      render :partial => "online_players", :layout => false
    end
  end
end
