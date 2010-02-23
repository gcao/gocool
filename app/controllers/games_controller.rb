class GamesController < ApplicationController
  def index
    @platform = params[:platform]
    @player1  = params[:player1]
    @player2  = params[:player2]

    if params[:op] == 'search'
      if @player1.blank?
        flash[:error] = t('games.player1_is_required')
      else
        @games = Game.search(@platform, @player1, @player2).sort_by_players
      end
    end
  end

  def show
    @game = Game.find params[:id]

    respond_to do |format|
      format.html { render :text => "" }
      format.sgf  { render :text => "" }
    end
  end

  def destroy
    Game.destroy(params[:id])
    render :text => 'SUCCESS'
  end
end
