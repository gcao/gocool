module GamesWidgetHelper
  def render_games_widget games
    return unless games

    @games_for_widget = games
    render :partial => 'games_widget/games'
  end
end
