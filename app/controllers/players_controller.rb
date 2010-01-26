class PlayersController < ApplicationController
  def index
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
    @name = params[:name]
    if @platform.blank?
      @players = Player.name_like(@name).with_stat
    else
      @players = OnlinePlayer.search(@platform, @name)
    end
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

    if @platform.blank?
      @players = Player.name_like(@name).first(10)
    else
      @players = OnlinePlayer.search(@platform, @name).first(10)
    end

    render :text => players_to_csv(@players)
  end

  def suggest2
    @player_id = params[:player_id]
    render :text => "" and return if @player_id.blank?

    @platform = params[:platform]
    @name = params[:name]
    @name = @name + "%" unless @name.blank?

    if @platform.blank?
      @pairs = PairStat.player_id_is(@player_id)
      @pairs = @pairs.opponent_name_like @name unless @name.blank?
      @pairs = @pairs.first(10)
    else
      @pairs = OnlinePairStat.player_id_is(@player_id)
      @pairs = @pairs.opponent_name_like @name unless @name.blank?
      @pairs = @pairs.first(10)
    end

    render :text => pairs_to_csv(@pairs)
  end

  private

  def players_to_csv players
    players.map{|player|
      "#{player.is_a?(Player) ? player.full_name : player.username}|#{player.id}"
    }.join("\n")
  end

  def pairs_to_csv pairs
    pairs.map{|pair|
      opponent = pair.opponent
      "#{opponent.is_a?(Player) ? opponent.full_name : opponent.username}|#{opponent.id}"
    }
  end
end
