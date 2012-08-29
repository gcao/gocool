module CoolGames
  module Api
    class InvitationsController < ::CoolGames::Api::BaseController
      JsonResponseHandler.apply(self, :methods => %w[index accept reject])

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

      def accept
        invitation = Invitation.find(params[:id])

        return JsonResponse.not_found unless invitation

        if invitation.state == 'new'
          invitation.invitee = current_player
          invitation.accept
          invitation.save!

          JsonResponse.success invitation.game
        elsif invitation.state == 'accepted'
          JsonResponse.success invitation.game
        else
          JsonResponse.failure invitation do
            add_error 'invalid_invitation_state', invitation.state
          end
        end
      end

      def reject
        invitation = Invitation.find(params[:id])

        return JsonResponse.not_found unless invitation

        if invitation.state == 'new'
          #invitation.reject
          #invitation.save!

          JsonResponse.success
        else
          JsonResponse.failure invitation do
            add_error 'invalid_invitation_state', invitation.state
          end
        end
      end
    end
  end
end

