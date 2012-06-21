module CoolGames
  module Api
    module BaseHelper
      def games_to_json games
        result = {}
        result[:games] = games
        result.to_json
      end
    end
  end
end

