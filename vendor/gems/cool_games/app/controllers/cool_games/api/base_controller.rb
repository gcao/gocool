module CoolGames
  module Api
    class BaseController < ActionController::Base
      include CoolGames::PaginationHelper

      helper 'cool_games/base', 'cool_games/pagination'

      protected

      def authenticate_user!
        @current_user = User.find_by_authentication_token(params[:token])
        respond_with({:error => "Token is invalid." }) unless @current_user
      end
    end
  end
end

