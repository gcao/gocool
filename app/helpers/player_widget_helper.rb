module PlayerWidgetHelper
  def render_player_widget player
    return unless player

    @player_for_widget = player
    render :partial => 'player_widget/player'
  end
end
