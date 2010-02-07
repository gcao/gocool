class Admin::PlayersController < Admin::BaseController
  active_scaffold :player do |config|
    config.columns = [:id, :full_name, :rank, :sex, :birth_year, :birth_place, :username, :other_names, :description]
    config.update.columns.remove :id
  end
end
