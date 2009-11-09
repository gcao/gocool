class GamesController < ApplicationController
  def index
    if params[:op] == 'search'
      first_player = params[:first_player]
      if first_player.blank?
        flash[:error] = t('games.first_player_is_required')
      else
        @games = Game.search(params[:platform], first_player, params[:second_player])
      end
    end
  end
end
