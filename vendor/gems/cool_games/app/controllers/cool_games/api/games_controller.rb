module CoolGames
  module Api
    class GamesController < ::CoolGames::Api::BaseController
      JsonResponseHandler.apply(self, :methods => %w[index search])

      before_filter :authenticate_user!, :only => %w[show]

      def index
        games = Game.sort_by_creation_time.paginate(page_params)

        JsonResponse.success(games)
      end

      def search
        if params[:player1].blank?
          JsonResponse.new(JsonResponse::VALIDATION_ERROR) do
            error_code = 'api.games.player1_is_required'
            add_error error_code, I18n.t(error_code), :player1
          end
        else
          @platform = params[:platform]
          @player1  = params[:player1]
          @player2  = params[:player2]

          games = Game.search(@platform, @player1, @player2).sort_by_players.paginate(page_params)

          JsonResponse.success(games)
        end
      end
    end
  end
end

