class DropOnlinePlayerViews < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "drop view online_player_games"
    ActiveRecord::Base.connection.execute "drop view online_player_won_games"
    ActiveRecord::Base.connection.execute "drop view online_player_lost_games"
  end

  def self.down
    # We are not going to rollback!
  end
end
