module PlayersWidgetHelper
  def render_players_widget players
    return unless players

    @players_for_widget = players.paginate page_params(:players_page)
    render :partial => 'players_widget/players'
  end
end
