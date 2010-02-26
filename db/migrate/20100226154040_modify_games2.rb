class ModifyGames2 < ActiveRecord::Migration
  def self.up
    remove_column :games, :for_rating
    add_column :games, :for_rating, :boolean
  end

  def self.down
  end
end
