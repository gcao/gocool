module CoolGames
  module Api
    class GamesController < ::CoolGames::Api::BaseController
      JsonResponseHandler.apply(self, :methods => %w[index search show])

      before_filter :authenticate_user!, :only => %w[play]
      before_filter :check_game, :only => %w[show play]

      def index
        respond_to do |format|
          format.html { render 'index' }
          format.json do
            games = Game.sort_by_creation_time.paginate(page_params)

            JsonResponse.success(games)
          end
        end
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

      def show
        respond_to do |format|
          format.html
          format.json do
            JsonResponse.success @game.to_json
          end
        end
      end

      private

      def check_game
        # html format is only used to setup page, then game data is retrived through ajax
        return if request.format.html?

        @game = Game.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render :json => JsonResponse.not_found.to_json, :callback => params['callback']
      end
    end
  end
end

