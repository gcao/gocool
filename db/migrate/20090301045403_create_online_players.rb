class CreateOnlinePlayers < ActiveRecord::Migration
  def self.up
    create_table :online_players do |t|
      t.integer    :gaming_platform_id
      t.string     :username
      t.date       :registered_at
      t.text       :description
      t.string     :updated_by
      t.timestamps
    end
    
    add_index :online_players, :gaming_platform_id
    add_index :online_players, :username
  end

  def self.down
    drop_table :online_players
  end
end
