class Admin::PlayersController < Admin::BaseController
  active_scaffold :player do |config|
    common_setup(config)
    
    config.label = I18n.t('players.page_title')
    config.action_links.add 'show', :label => I18n.t('form.show_button'),:parameters => {:controller => '/players'}, :type => :member, :page => true, :popup => true
    
    config.columns = [:id, :gaming_platform_id, :gaming_platform, :name, :rank, :sex, :birth_year, :birth_place, :other_names, :description]

    config.columns[:id                ].label = "ID"
    config.columns[:gaming_platform_id].label = config.columns[:gaming_platform].label = I18n.t('players_table.platform')
    config.columns[:name              ].label = I18n.t('players_table.name_username')
    config.columns[:rank              ].label = I18n.t('players_table.rank')
    config.columns[:sex               ].label = I18n.t('players_table.sex')
    config.columns[:birth_year        ].label = I18n.t('players_table.birth_year')
    config.columns[:birth_place       ].label = I18n.t('players_table.birth_place')
    config.columns[:other_names       ].label = I18n.t('players_table.other_names')
    config.columns[:description       ].label = I18n.t('players_table.description')

    config.list.columns.remove :gaming_platform_id
    config.show.columns.remove :gaming_platform
    config.create.columns.remove :id, :gaming_platform
    config.update.columns.remove :id, :gaming_platform
  end
end
