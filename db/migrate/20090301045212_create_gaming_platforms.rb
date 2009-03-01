class CreateGamingPlatforms < ActiveRecord::Migration
  def self.up
    create_table :gaming_platforms do |t|
      t.integer :nation_region_id
      t.string :name
      t.string :url
      t.boolean :is_turn_based
      t.text :description
      t.string :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :gaming_platforms
  end
end
