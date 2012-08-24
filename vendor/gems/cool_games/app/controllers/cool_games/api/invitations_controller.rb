module CoolGames
  module Api
    class InvitationsController < ::CoolGames::Api::BaseController
      JsonResponseHandler.apply(self, :methods => %w[index show])

      before_filter :authenticate_user!

      def index
        respond_to do |format|
          format.html { render 'index' }
          format.json do
            invitations = Invitation.active.to_me(@current_player)

            JsonResponse.success(invitations)
          end
        end
      end
    end
  end
end

