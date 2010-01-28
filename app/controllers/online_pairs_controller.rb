class OnlinePairsController < ApplicationController
  def show
    @pair = OnlinePairStat.find(params[:id])
    @online = true
    @games = Game.played_between(@pair.player.id, @pair.opponent.id).gaming_platform_id_is(@pair.gaming_platform_id)
  end
end
