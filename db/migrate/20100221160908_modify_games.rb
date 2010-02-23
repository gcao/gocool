class ModifyGames < ActiveRecord::Migration
  def self.up
    remove_column :games, :is_online_game
    rename_column :games, :start_color, :start_side
    rename_column :games, :status, :state
    add_column :games, :for_rating, :string
  end

  def self.down
  end
end
