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
#      if @players.size == 1
#      else
        render :partial => "players", :layout => false
#      end
    else
      @players = OnlinePlayer.search(@platform, @name).paginate(page_params)
#      if @players.size == 1
#      else
        render :partial => "online_players", :layout => false
#      end
    end
  end

  def suggest
    @name = params[:name]
    render :text => "" and return if @name.blank?

    @name = "#{@name}*"
    @platform = params[:platform]

    if @platform.blank?
      @players = Player.name_like(@name).first(10)
    else
      @players = OnlinePlayer.search(@platform, @name).first(10)
    end

    render :text => @players.map{|player|
      "#{player.is_a?(Player) ? player.full_name : player.username}|#{player.id}"
    }.join("\n")
  end
end
