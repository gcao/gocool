class GamesController < ApplicationController
  before_filter :login_required, :only => [:play, :resign]

  def index
    @platform = params[:platform]
    @player1  = params[:player1]
    @player2  = params[:player2]

    if params[:op] == 'search'
      if @player1.blank?
        flash.now[:error] = t('games.player1_is_required')
      else
        @games = Game.search(@platform, @player1, @player2).sort_by_players
      end
    end
  end

  def show
    @game = Game.find params[:id]

    respond_to do |format|
      format.html { render :layout => 'simple' }
      format.sgf  { render :text => SgfRenderer.new(@game).render }
    end
  end

  def destroy
    Game.destroy(params[:id])
    render :text => 'SUCCESS'
  end

  def play
    @game = Game.find params[:id]
    raise "Game #{params[:id]} is not found!" unless @game

    code, message = @game.play params
    if code == GameInPlay::OP_SUCCESS
      render :text => "#{code}:#{SgfRenderer.new(@game).render}"
    else
      render :text => "#{code}:#{message}"
    end
  end

  def resign
    @game = Game.find params[:id]
    raise "Game #{params[:id]} is not found!" unless @game

    if @game.current_user_is_player?
      code, message = @game.resign
      render :text => "#{code}:#{message}"
    else
      render :text => "1:#{t('games.user_is_not_player')}"
    end
  end
end
