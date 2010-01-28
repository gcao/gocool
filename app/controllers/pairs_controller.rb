class PairsController < ApplicationController
  def index
    @platform_name   = params[:platform]
    @player1_name    = params[:player1]
    @player2_name    = params[:player2]

    if params[:op] == 'search'
      @status = :success

      if @platform_name.blank?
        @player1 = Player.full_name_is(@player1_name).first
        @player2 = Player.full_name_is(@player2_name).first
      else
        @platform = GamingPlatform.name_is(@platform_name).first
        @player1 = OnlinePlayer.gaming_platform_id_is(@platform.id).username_is(@player1).first
        @player2 = OnlinePlayer.gaming_platform_id_is(@platform.id).username_is(@player2).first
      end

      if @player1.blank? or @player2.blank?
        @status = :player_not_found
        @errors = []
        @errors << ['player1', t('pairs.player_not_found')] if @player1.blank?
        @errors << ['player2', t('pairs.player_not_found')] if @player2.blank?
      else
        if @platform.blank?
          @pair = PairStat.player_id_is(@player1.id).opponent_id_is(@player2.id).first
        else
          @online = true
          @pair = OnlinePairStat.player_id_is(@player1.id).opponent_id_is(@player2.id).first
        end

        if @pair
          @games = Game.played_between(@player1.id, @player2.id)
          gaming_platform_id = @platform.blank? ? nil : @platform.id
          @games = @games.gaming_platform_id_is(gaming_platform_id)
          if @games.count == 0
            @status = :pair_not_found
          end
        else
          @status = :pair_not_found
        end
      end
    end
  end
end
