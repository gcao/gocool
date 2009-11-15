module GamesWidgetHelper
  def render_games_widget games
    render 'games_widget/games', :locals => {:games => games} if games
  end
end