module CoolGames
  module Api
    class GamesController < ::CoolGames::Api::BaseController
      def index
        if params[:player1].blank?
          games = Game
        else
          games = Game.search(@platform, @player1, @player2)
        end

        render :text => games.sort_by_players.paginate.to_json
      end
    end
  end
end

