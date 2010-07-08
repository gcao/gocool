class Admin::GamesController < Admin::BaseController
  active_scaffold :game do |config|
    common_setup(config)
    
    config.label = I18n.t('games.page_title')
    config.action_links.add 'show', :label => I18n.t('form.view_button'),:parameters => {:controller => '/games'}, :type => :member, :page => true, :popup => true
    
    config.columns = [:id, :name, :gaming_platform_id, :gaming_platform, :black_id, :black_name, :black_rank,
                      :white_id, :white_name, :white_rank, :result, :winner, :winner_str, :moves,
                      :handicap, :komi_raw, :rule_raw, :played_at, :played_at_raw, :place]

    config.columns[:id             ].label = "ID"
    config.columns[:name           ].label = I18n.t('games_widget.game_name')
    config.columns[:gaming_platform].label = config.columns[:gaming_platform_id].label = I18n.t("games_widget.platform")
    config.columns[:black_id       ].label = I18n.t("games_widget.black_player")
    config.columns[:black_name     ].label = I18n.t("games_widget.black_player_name")
    config.columns[:black_rank     ].label = I18n.t("games_widget.black_rank")
    config.columns[:white_id       ].label = I18n.t("games_widget.white_player")
    config.columns[:white_name     ].label = I18n.t("games_widget.white_player_name")
    config.columns[:white_rank     ].label = I18n.t("games_widget.white_rank")
    config.columns[:result         ].label = I18n.t("games_widget.result")
    config.columns[:winner         ].label = config.columns[:winner_str].label = I18n.t("games_widget.winner")
    config.columns[:moves          ].label = I18n.t("games_widget.moves")
    config.columns[:handicap       ].label = I18n.t("games_widget.handicap")
    config.columns[:komi_raw       ].label = I18n.t("games_widget.komi")
    config.columns[:rule_raw       ].label = I18n.t("games_widget.rule")
    config.columns[:played_at      ].label = I18n.t("games_widget.play_time")
    config.columns[:played_at_raw  ].label = I18n.t("games_widget.play_time")
    config.columns[:place          ].label = I18n.t("games_widget.place")

    config.list.columns.remove :gaming_platform_id, :winner, :played_at_raw
    config.show.columns.remove :gaming_platform, :winner_str, :played_at_raw
    config.create.columns.remove :id, :gaming_platform, :winner_str
    config.update.columns.remove :id, :gaming_platform, :winner_str
  end
end
