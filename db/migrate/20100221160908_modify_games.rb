class ModifyGames < ActiveRecord::Migration
  def self.up
    remove_column :games, :is_online_game
    rename_column :games, :status, :state
  end

  def self.down
  end
end
