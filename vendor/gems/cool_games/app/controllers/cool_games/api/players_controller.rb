module CoolGames
  module Api
    class PlayersController < ::CoolGames::Api::BaseController
      JsonResponseHandler.apply(self, :methods => %w[index search show])

      def index
        respond_to do |format|
          format.html
          format.json do
            players = Player.order_by([[:name]]).paginate(page_params)

            JsonResponse.success(players)
          end
        end
      end

      def search
        if params[:name].blank?
          JsonResponse.new(JsonResponse::VALIDATION_ERROR) do
            error_code = 'api.players.name_is_required'
            add_error error_code, I18n.t(error_code), :name
          end
        else
          @name  = params[:name]

          players = Player.search(name).paginate(page_params)

          JsonResponse.success(players)
        end
      end

      def show
        respond_to do |format|
          format.html

          format.json do
            JsonResponse.success @player
          end
        end
      end
    end
  end
end

