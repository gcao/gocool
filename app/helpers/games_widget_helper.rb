module GamesWidgetHelper
  def render_games_widget games
    return unless games

    @games_for_widget = games.paginate page_params(:games_page)
    render :partial => 'games_widget/games'
  end
end
