module CoolGames
  module Api
    class GamesController < ::CoolGames::Api::BaseController
      respond_to :json

      def index
        if params[:player1].blank?
          games = Game
        else
          games = Game.search(@platform, @player1, @player2)
        end

        render :json => JsonResponse.new(200, games.sort_by_players.paginate(page_params))
      end
    end
  end
end

