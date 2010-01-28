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
    @opponent_name = params[:name]
    if @platform.blank?
      @players = Player.name_like(@opponent_name).with_stat
    else
      @players = OnlinePlayer.search(@platform, @opponent_name)
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
    @player_name = params[:player]
    render :text => "" and return if @player_name.blank?

    @platform = params[:platform]
    @opponent_name = params[:opponent]
    @opponent_name += "%" unless @opponent_name.blank?

    if @platform.blank?
      @player = Player.full_name_is(@player_name).first
      render :text => "" and return if @player.blank?

      @pairs = PairStat.player_id_is(@player.id)
      @pairs = @pairs.opponent_name_like @opponent_name unless @opponent_name.blank?
      @pairs = @pairs.first(10)
    else
      @player = OnlinePlayer.search(@platform, @player_name).first
      render :text => "" and return if @player.blank?

      @pairs = OnlinePairStat.player_id_is(@player.id)
      @pairs = @pairs.opponent_name_like @opponent_name unless @opponent_name.blank?
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
