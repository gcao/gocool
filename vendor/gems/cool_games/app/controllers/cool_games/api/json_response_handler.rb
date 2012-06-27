module CoolGames
  module Api
    class JsonResponseHandler < Aspector::Base
      after do |result|
        respond_with result if result.is_a? JsonResponse
      end
    end
  end
end

