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

        resp = JsonResponse.new
        resp.body = games.sort_by_players.paginate(page_params)

        render :json => resp.to_s
      end
    end
  end
end

