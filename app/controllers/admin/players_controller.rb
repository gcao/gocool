class Admin::PlayersController < Admin::BaseController
  active_scaffold :player do |config|
    config.columns = [:id, :gaming_platform_id, :gaming_platform, :name, :rank, :sex, :birth_year, :birth_place, :other_names, :description]
    config.update.columns.remove :id
  end
end
