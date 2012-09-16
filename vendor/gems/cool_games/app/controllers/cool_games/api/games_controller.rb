module CoolGames
  module Api
    class GamesController < ::CoolGames::Api::BaseController
      JsonResponseHandler.apply(self, :methods => %w[index search my_turn show play resign undo_guess_moves])

      before_filter :authenticate_user!, :only => %w[my_turn play resign undo_guess_moves]
      before_filter :check_game, :only => %w[show play resign undo_guess_moves]

      def index
        respond_to do |format|
          format.html
          format.json do
            games = Game.order_by([[:creation_time]]).paginate(page_params)

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

      def my_turn
        games = Game.order_by([[:creation_time]]).my_turn(@current_player)

        JsonResponse.success(games)
      end

      def show
        respond_to do |format|
          format.html

          format.json do
            JsonResponse.success @game
          end

          format.sgf do
            sgf = CoolGames::Sgf::GameRenderer.new.render(@game)

            render :text => sgf
          end
        end
      end

      def play
        code, message = @game.play params
        if code == GameInPlay::OP_SUCCESS
          JsonResponse.success CoolGames::Sgf::GameRenderer.new.render(@game)
        else
          JsonResponse.failure message
        end
      end

      def resign
        code, message = @game.resign
        if code == GameInPlay::OP_SUCCESS
          JsonResponse.success CoolGames::Sgf::GameRenderer.new.render(@game)
        else
          JsonResponse.failure message
        end
      end

      def undo_guess_moves
        @game.undo_guess_moves
        JsonResponse.success
      end

      private

      def check_game
        @game = Game.find params[:id]
      rescue
        if request.format.json?
          render :json => JsonResponse.not_found, :callback => params['callback']
        else
          raise
        end
      end
    end
  end
end

