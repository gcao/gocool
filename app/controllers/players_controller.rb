class PlayersController < ApplicationController
  def index
  end

  def auto_complete_for_name
    if params[:platform_id].blank?
      find_options = {
        :conditions => [ "players.name LIKE ?", "%#{params[:name].downcase}%" ],
        :order => "players.name ASC",
        :limit => 10 }

      @items = Player.find(:all, find_options)

      render :inline => "<%= auto_complete_result @items, 'name' %>"
    else
      render :text => ""
    end
  end

  def show
    @player = Player.find params[:id]
    @games = Game.by_player(@player).sort_by_players

    @games_total = @player.stat.games
    @games_won = @player.stat.games_won
    @games_lost = @player.stat.games_lost

    @opponents = @player.opponents.sort_by_opponent_name
  end

  def search
    @platform = params[:platform]
    @opponent_name = params[:name]
    @players = Player.search(@platform, @opponent_name).with_stat

    if @players.size == 1
      render_player_widget @players.first
    else
      render_players_widget @players
    end
  end

  def suggest
    @name = params[:name]
    render :text => "" and return if @name.blank?

    @name = "#{@name}*"
    @platform = params[:platform]

    @players = Player.search(@platform, @name).first(10)

    render :text => players_to_csv(@players)
  end

  def suggest_opponents
    @player_name = params[:player]
    render :text => "" and return if @player_name.blank?

    @platform = params[:platform]
    @opponent_name = params[:opponent]
    @opponent_name += "%" unless @opponent_name.blank?

    @player = Player.search(@platform, @player_name).first
    render :text => "" and return if @player.blank?

    @pairs = PairStat.player_id_is(@player.id)
    @pairs = @pairs.opponent_name_like @opponent_name unless @opponent_name.blank?
    @pairs = @pairs.first(10)

    render :text => pairs_to_csv(@pairs)
  end

  private

  def players_to_csv players
    players.map{|player|
      "#{player.name}|#{player.id}"
    }.join("\n")
  end

  def pairs_to_csv pairs
    pairs.map{|pair|
      opponent = pair.opponent
      "#{opponent.name}|#{opponent.id}"
    }.join("\n")
  end
end
