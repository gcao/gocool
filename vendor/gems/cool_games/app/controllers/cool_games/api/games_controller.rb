module CoolGames
  module Api
    class GamesController < ::CoolGames::Api::BaseController
      def index
        if params[:player1].blank?
          games = Game
        else
          games = Game.search(@platform, @player1, @player2)
        end

        render :text => games_to_json(games.sort_by_players.paginate(page_params))
      end
    end
  end
end

