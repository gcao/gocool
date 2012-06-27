module CoolGames
  module Api
    class JsonResponseHandler < Aspector::Base
      after do |result|
        if result.is_a? JsonResponse
          if params[:callback].blank?
            respond_with result
          else
            render :text => "#{params['callback']}(#{result.to_json})", :content_type => "text/javascript"
          end
        end
      end
    end
  end
end

