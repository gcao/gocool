class Admin::OnlinePlayersController < Admin::BaseController
  active_scaffold :online_player do |config|
    config.columns = [:id, :username, :rank, :gaming_platform, :player, :description]
    config.update.columns.remove :id
  end
end
