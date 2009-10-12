require "migration_helpers"

class CreateOnlinePlayers < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :online_players do |t|
      t.integer    :player_id
      t.integer    :gaming_platform_id, :null => false
      t.string     :username, :null => false
      t.date       :registered_at
      t.text       :description
      t.string     :updated_by
      t.timestamps
    end
    
    add_index :online_players, :player_id
    add_index :online_players, [:gaming_platform_id, :username]
    add_foreign_key :online_players, :gaming_platform_id, :gaming_platforms
  end

  def self.down
    drop_table :online_players
  end
end
