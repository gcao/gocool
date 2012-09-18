module CoolGames
  module Api
    class InvitationsController < ::CoolGames::Api::BaseController
      JsonResponseHandler.apply(self, :methods => %w[index create accept reject cancel])

      before_filter :authenticate_user!

      aspector do
        before :accept, :reject, :cancel do
          begin
            @invitation = Invitation.find params[:id]
          rescue
            if request.format.json?
              returns JsonResponse.not_found
            else
              raise
            end
          end
        end
      end

      def index
        respond_to do |format|
          format.html { render 'index' }
          format.json do
            invitations = Invitation.includes(:inviter).active.of_player(@current_player)

            JsonResponse.success(invitations)
          end
        end
      end

      def new
        @invitees = params[:invitees]
      end

      def create
        @invitees   = params["invitation"].delete("invitees")
        @start_side = params["invitation"]["start_side"]
        @note       = params["invitation"]["note"]

        @game_type = Game::WEIQI
        @game_type = Game::DAOQI if params['invitation'].delete('game_type') == Game::DAOQI.to_s

        invitees, unrecognized = Invitation.parse_invitees(@invitees)

        if unrecognized.blank?
          invitees.each do |invitee|
            attrs = params[:invitation].merge(:invitee => invitee,
                                              :inviter => @current_player, 
                                              :game_type => @game_type)
            invitation = Invitation.new(attrs)
            invitation.save!
          end

          JsonResponse.success
        else
          JsonResponse.new JsonResponse::VALIDATION_ERROR do
            error_code = :invitee_not_found
            message = t('invitations.user_not_found').gsub('USERNAME', unrecognized.join(", "))
            add_error error_code, message, "invitation_invitees"
          end
        end
      end

      def accept
        @invitation.accept

        if @invitation.state == 'accepted'
          @invitation.save!

          JsonResponse.success @invitation
        else
          JsonResponse.failure @invitation do
            add_error 'invalid_invitation_state', @invitation.state
          end
        end
      end

      def reject
        @invitation.reject

        if @invitation.state == 'rejected'
          @invitation.save!

          JsonResponse.success
        else
          JsonResponse.failure @invitation do
            add_error 'invalid_invitation_state', @invitation.state
          end
        end
      end

      def cancel
        @invitation.cancel

        if @invitation.state == 'canceled'
          @invitation.save!

          JsonResponse.success
        else
          JsonResponse.failure @invitation do
            add_error 'invalid_invitation_state', @invitation.state
          end
        end
      end

    end
  end
end

