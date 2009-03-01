class CreateOnlinePlayers < ActiveRecord::Migration
  def self.up
    create_table :online_players do |t|
      t.integer :player_id, :gaming_platform_id
      t.string :username
      t.date :registered_at
      t.text :description
      t.string :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :online_players
  end
end
