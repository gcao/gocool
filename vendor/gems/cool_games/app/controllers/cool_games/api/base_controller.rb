module CoolGames
  module Api
    class BaseController < ActionController::Base
      include CoolGames::PaginationHelper

      helper 'cool_games/base', 'cool_games/pagination'

      layout 'application'

      #respond_to :html, :json, :sgf

      before_filter do
        @server2js = {
          :auth_token => session[:auth_token]
        }
      end

      before_filter :authenticate_user

      protected

      def authenticate_user
        unless params[:auth_token].blank?
          Thread.current[:user] = @current_user = User.find_by_authentication_token(params[:auth_token])
          @current_player = @current_user.nil_or.player
        end
      end

      def authenticate_user!
        return if request.format.html?

        unless @current_user
          render :json => JsonResponse.not_authenticated.as_json, :callback => params['callback']
        end
      end
    end
  end
end

