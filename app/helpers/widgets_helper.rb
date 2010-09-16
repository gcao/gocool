module WidgetsHelper
  def render_games games
    render :partial => 'games_widget/games', :locals => {:games => games.paginate(page_params(:games_page))}
  end
end
