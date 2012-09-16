module CoolGames
  module Api
    class BaseController < ActionController::Base
      include CoolGames::PaginationHelper

      helper 'cool_games/base', 'cool_games/pagination'

      layout 'application'

      #respond_to :html, :json, :sgf

      before_filter do
        gon.auth_token = session[:auth_token]
        gon.user = current_user.username if user_signed_in?
        gon.urls = {
          games: cool_games.games_path,
          api: {
            players:     cool_games.api_players_path,
            games:       cool_games.api_games_path,
            invitations: cool_games.api_invitations_path,
            login:       main_app.api_sessions_path
          }
        }
      end

      before_filter :authenticate_user

      protected

      def authenticate_user
        if params[:login].not_blank? and params[:password].not_blank?
          user = User.find_first_by_auth_conditions(:login => params[:login])
          user = nil unless user.valid_password?(params[:password])
        elsif params[:auth_token].not_blank?
          user = User.find_by(authentication_token: params[:auth_token])
        end

        if user
          Thread.current[:user] = @current_user = user
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

