class PairsController < ApplicationController
  def index
    @platform     = params[:platform]
    @player1_name = params[:player1]
    @player2_name = params[:player2]

    if params[:op] == 'search'
      @status = :success

      @player1 = Player.on_platform(@platform).find_by_name(@player1_name)
      @player2 = Player.on_platform(@platform).find_by_name(@player2_name)

      if @player1.blank? or @player2.blank?
        @status = :player_not_found
        @errors = []
        @errors << ['player1', t('pairs.player_not_found').gsub('PLAYER_NAME', @player1_name)] if @player1.blank?
        @errors << ['player2', t('pairs.player_not_found').gsub('PLAYER_NAME', @player2_name)] if @player2.blank?
      else
        @pair = PairStat.player_id_is(@player1.id).opponent_id_is(@player2.id).first

        if @pair
          @games = Game.played_between(@player1.id, @player2.id)
          if @games.count == 0
            @status = :pair_not_found
          end
        else
          @status = :pair_not_found
        end
      end
    end
  end

  def show
    @pair = PairStat.find(params[:id])
    @games = Game.played_between(@pair.player.id, @pair.opponent.id)
  end
end
