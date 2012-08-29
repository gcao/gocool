module CoolGames
  module Api
    class JsonResponseHandler < Aspector::Base
      after do |result|
        if result.is_a? JsonResponse
          render :json => result.as_json, :callback => params['callback']
        end
      end
    end
  end
end

