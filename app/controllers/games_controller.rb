class GamesController < ApplicationController
  def index
    @platform = params[:platform]
    @player1  = params[:player1]
    @player2  = params[:player2]

    if params[:op] == 'search'
      if @player1.blank?
        flash[:error] = t('games.player1_is_required')
      else
        @games = Game.search(@platform, @player1, @player2).
                      paginate(page_params)
      end
    end
  end
end
