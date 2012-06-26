module CoolGames
  module Api
    class BaseController < ActionController::Base
      include CoolGames::BaseHelper, BaseHelper
      helper 'cool_games/base'

      respond_to :json

      def page_params page_no_param = :page
        page_size = (ENV['ROWS_PER_PAGE'] || 15).to_i
        { :per_page => page_size, :page => params[page_no_param] }
      end
      helper_method :page_params

      protected

      def authenticate_user!
        @current_user = User.find_by_authentication_token(params[:token])
        respond_with({:error => "Token is invalid." }) unless @current_user
      end
    end
  end
end

