class PairsController < ApplicationController
  def index
    @platform   = params[:platform]
    @player1    = params[:player1]
    @player1_id = params[:player1_id]
    @player2    = params[:player2]
    @player2_id = params[:player2_id]

    unless @player1_id.blank? or @player2_id.blank?
      if @platform.blank?
        @pair = PairStat.player_id_is(@player1_id).opponent_id_is(@player2_id).first
        @games = Game.on_platform(nil).played_between(@player1_id, @player2_id).paginate(page_params)
      else
        @online = true
        @pair = OnlinePairStat.player_id_is(@player1_id).opponent_id_is(@player2_id).first
        @games = Game.on_platform(@platform).played_between(@player1_id, @player2_id).paginate(page_params)
      end
    end
  end
end
