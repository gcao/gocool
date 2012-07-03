module CoolGames
  module Api
    class BaseController < ActionController::Base
      include CoolGames::PaginationHelper

      helper 'cool_games/base', 'cool_games/pagination'

      respond_to :json

      before_filter :authenticate_user

      protected

      def authenticate_user
        unless params[:token].blank?
          @current_user = User.find_by_authentication_token(params[:token])
        end
      end

      def authenticate_user!
        unless @current_user
          render :json => JsonResponse.not_authenticated.to_json, :callback => params['callback']
        end
      end
    end
  end
end

