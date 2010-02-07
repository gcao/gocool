class Admin::GamingPlatformsController < Admin::BaseController
  active_scaffold :gaming_platform do |config|
    config.columns = [:id, :name, :url, :description]
    config.update.columns.remove :id
  end
end
