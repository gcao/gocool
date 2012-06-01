module CoolGames
  module WidgetsHelper
    def render_games games
      render :partial => 'cool_games/widgets/games', :locals => {:games => games.paginate(page_params(:games_page))}
    end

    def render_players players
      render :partial => 'cool_games/widgets/players', :locals => {:players => players.paginate(page_params(:players_page))}
    end

    def render_uploads uploads
      render :partial => 'cool_games/widgets/uploads', :locals => {:uploads => uploads.paginate(page_params(:uploads_page))}
    end

    def render_opponents opponents
      render :partial => 'cool_games/widgets/opponents', :locals => {:opponents => opponents.paginate(page_params(:opponents_page))}
    end
  end
end
