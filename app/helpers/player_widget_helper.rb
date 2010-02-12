module PlayerWidgetHelper
  def render_player_widget player
    return unless player

    @player_for_widget = player
    render :partial => 'player_widget/player'
  end

  def player_widget_header
    platform_name = @player_for_widget.gaming_platform.nil_or.name.to_s
    t('players.games_played_by').gsub('PLAYER_NAME', @player_for_widget.name.to_s).gsub('PLATFORM_NAME', platform_name)
  end
end
