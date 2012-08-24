module CoolGames
  module Api
    class JsonResponseHandler < Aspector::Base
      after do |result|
        if result.is_a? JsonResponse
          result.user = current_user.username if user_signed_in?
          render :json => result, :callback => params['callback']
        end
      end
    end
  end
end

