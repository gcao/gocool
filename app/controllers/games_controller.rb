class GamesController < ApplicationController
  def index
    if params[:op] == 'search'
      first_player = params[:first_player]
      if first_player.blank?
        flash[:error] = t('games.first_player_is_required')
      else
        @games = Game.search(params[:platform], first_player, params[:second_player]).
                      paginate(:per_page => ENV['ROWS_PER_PAGE'].to_i, :page => params[:page])
      end
    end
  end
end
