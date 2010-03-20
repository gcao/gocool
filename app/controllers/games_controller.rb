class GamesController < ApplicationController
  before_filter :check_game, :except => [:new, :index, :next, :waiting, :destroy]
  before_filter :login_required, :only => [:play, :resign, :undo_guess_moves, :do_this]
  before_filter :check_user_is_player, :only => [:undo_guess_moves, :do_this]

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
    respond_to do |format|
      format.html do
        set_flash_message
        render :layout => 'simple'
      end

      format.sgf  { render :text => SgfRenderer.new(@game).render }
    end
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
    code, message = @game.play params
    if code == GameInPlay::OP_SUCCESS
      render :text => "#{code}:#{SgfRenderer.new(@game).render}"
    else
      render :text => "#{code}:#{message}"
    end
  end

  def resign
    if @game.current_user_is_player?
      code, message = @game.resign
      render :text => "#{code}:#{message}"
    else
      render :text => "#{GameInPlay::OP_FAILURE}:#{t('games.user_is_not_player')}"
    end
  end

  def undo_guess_moves
    @game.undo_guess_moves
    render 'show', :layout => 'simple'
  end

  def do_this
    op = params[:op]
    if %w(request_counting reject_counting_request resume accept_counting reject_counting).include?(op)
      send(op)
      @game.save!
    else
      flash.now[:error] = t('games.unsupported_operation')
    end
    redirect_to :action => :show
  end

  private

  def check_game
    @game = Game.find params[:id]
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t('games.not_found').sub('GAME_NO', params[:id])
    redirect_to :controller => 'misc', :action => 'error'
  end

  def check_user_is_player
    unless @game.current_user_is_player?
      flash.now[:error] = t('games.user_is_not_player')
      render 'show', :layout => 'simple'
    end
  end

  def request_counting
    @game.undo_guess_moves
    @game.request_counting
    if @game.state == 'counting' and not @game.detail.last_move.move_on_board?
      move = GameMove.create!(:game_detail_id => @game.detail.id, :move_no => @game.detail.last_move.move_no,
                          :color => Game::NONE, :x => -1, :y => -1, :played_at => Time.now,
                          :parent_id => @game.detail.last_move_id)
      @game.detail.last_move_id = move.id
      @game.detail.save!
    end
  end

  def reject_counting_request
    @game.reject_counting_request
  end

  def accept_counting
    @game.accept_counting
  end

  def reject_counting
    @game.reject_counting
  end

  def resume
    @game.resume
  end

  def find_next games, current_game_id
    found = false
    games.each do |game|
      return game if found
      
      found = true if current_game_id.to_i == game.id
    end
    games.first
  end

  def set_flash_message
    case @game.state
      when 'playing' then
        flash.now[:notice] = t('games.request_counting').gsub('GAME_URL', game_url(@game))
      when 'black_request_counting' then
        if @game.current_user_is_black?
          flash.now[:notice] = t('games.requested_counting').gsub('GAME_URL', game_url(@game))
        elsif @game.current_user_is_white?
          flash.now[:error] = t('games.opponent_requested_counting').gsub('GAME_URL', game_url(@game))
        end
      when 'white_request_counting' then
        if @game.current_user_is_white?
          flash.now[:notice] = t('games.requested_counting').gsub('GAME_URL', game_url(@game))
        elsif @game.current_user_is_black?
          flash.now[:error] = t('games.opponent_requested_counting').gsub('GAME_URL', game_url(@game))
        end
      when 'counting' then
        flash.now[:notice] = t('games.start_counting').gsub('GAME_URL', game_url(@game))
      when 'black_accept_counting' then
        if @game.current_user_is_black?
          flash.now[:notice] = t('games.accepted_counting').gsub('GAME_URL', game_url(@game))
        elsif @game.current_user_is_white?
          flash.now[:error] = t('games.opponent_accepted_counting').gsub('GAME_URL', game_url(@game))
        end
      when 'white_accept_counting' then
        if @game.current_user_is_white?
          flash.now[:notice] = t('games.accepted_counting').gsub('GAME_URL', game_url(@game))
        elsif @game.current_user_is_black?
          flash.now[:error] = t('games.opponent_accepted_counting').gsub('GAME_URL', game_url(@game))
        end
    end
  end
end
