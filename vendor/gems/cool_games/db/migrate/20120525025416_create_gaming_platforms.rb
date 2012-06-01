class CreateGamingPlatforms < ActiveRecord::Migration
  def up
    create_table :cg_gaming_platforms do |t|
      t.integer    :nation_region_id
      t.string     :name, :null => false, :unique => true
      t.string     :url
      t.boolean    :is_turn_based
      t.text       :description
      t.string     :updated_by
      t.timestamps
    end
  end

  def down
  end
end
