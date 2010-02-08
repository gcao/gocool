class Admin::OnlinePlayersController < Admin::BaseController
  active_scaffold :online_player do |config|
    config.columns = [:id, :username, :rank, :gaming_platform_id, :gaming_platform, :player, :description]
    config.list.columns.remove :gaming_platform_id
    config.update.columns.remove :id, :gaming_platform
    config.show.columns.remove :gaming_platform
  end
end
