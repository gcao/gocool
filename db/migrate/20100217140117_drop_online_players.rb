class DropOnlinePlayers < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS decrement_online_pair_stats"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS increment_online_pair_stats"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS reset_online_pair_stats"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS decrement_online_player_stats"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS increment_online_player_stats"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS reset_online_player_stats"
    drop_table :online_pair_stats
    drop_table :online_player_stats
    drop_table :online_players
  end

  def self.down
  end
end
