module Api
  class SessionsController < ActionController::Base
    layout 'application'

    CoolGames::Api::JsonResponseHandler.apply(self, :methods => %w[create destroy])

    def index
    end

    def create
      login    = params[:login]
      password = params[:password]

      if login.blank? or password.blank?
        return CoolGames::Api::JsonResponse.new(CoolGames::Api::JsonResponse::LOGIN_FAILURE) do
          if login.blank?
            error_code = 'api.login.login_is_required'
            add_error error_code, I18n.t(error_code), :login
          end
          if password.blank?
            error_code = 'api.login.password_is_required'
            add_error error_code, I18n.t(error_code), :password
          end
        end
      end

      @user = User.find_first_by_auth_conditions(:login => login)

      if @user.nil?
        logger.info("User #{login} is not found.")
        return CoolGames::Api::JsonResponse.new(CoolGames::Api::JsonResponse::LOGIN_FAILURE) do
          error_code = 'api.login.user_not_found'
          add_error error_code, I18n.t(error_code), :login
        end
      end

      # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
      @user.ensure_authentication_token!

      if @user.valid_password?(password)
        return JsonResponse.success(@user.authentication_token)
      else
        logger.info("User #{login} failed to sign in due to bad password.")
        return CoolGames::Api::JsonResponse.new(CoolGames::Api::JsonResponse::LOGIN_FAILURE) do
          error_code = 'api.login.bad_password'
          add_error error_code, I18n.t(error_code), :password
        end
      end
    end

    def destroy
      @user = User.find_by_authentication_token(params[:token])
      @user.nil_or.reset_authentication_token!

      render :text => "success"
    end

  end
end

