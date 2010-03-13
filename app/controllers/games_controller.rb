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

  def prev
    render :text => "TODO"
  end

  def next
    if logged_in?
      # Find waiting games, locate position of current game, return game immediately after current game, return first game if current is last
      games = Game.my_turn(current_player).not_finished.sort_by_last_move_time
      if games.size == 0
        # If there is no waiting games, jump between games that are waiting for opponents to play
        games = Game.by_player(current_player).not_finished.sort_by_last_move_time
        if games.size == 0
          flash[:notice] = t('games.no_other_game')
          redirect_to game_url(params[:id])
        elsif games.size == 1
          game = games.first
          flash[:notice] = t('games.no_other_game') if game.id == params[:id].to_i
          redirect_to game_url(game)
        else
          next_game = find_next(games, params[:id])
          redirect_to game_url(next_game)
        end
      elsif games.size == 1
        game = games.first
        flash[:notice] = t('games.no_other_waiting_game') if game.id == params[:id].to_i
        redirect_to game_url(game)
      else
        next_game = find_next(games, params[:id])
        redirect_to game_url(next_game)
      end
    else
      flash[:notice] = t('games.next_game_not_logged_in')
      render game_url(params[:id])
    end
  end

  def my_turn
    if logged_in? and not Game.my_turn(current_player).not_finished.blank?
      render :text => 'true'
    else
      render :text => 'false'
    end
  end

  def waiting
    if logged_in? and game = Game.my_turn(current_player).not_finished.first
      redirect_to game_url(game)
    else
      redirect_to root_url
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
      render :text => "#{GameInPlay::OP_FAILURE}:#{t('games.user_is_not_player')}"
    end
  end

  def undo_guess_moves
    @game = Game.find params[:id]
    raise "Game #{params[:id]} is not found!" unless @game

    if @game.current_user_is_player?
      @game.undo_guess_moves
      redirect_to :action => :show
    else
      render :text => "#{GameInPlay::OP_FAILURE}:#{t('games.user_is_not_player')}"
    end
  end

  private

  def find_next games, current_game_id
    found = false
    games.each do |game|
      return game if found
      
      found = true if current_game_id.to_i == game.id
    end
    games.first
  end
end
