class CreateNationRegions < ActiveRecord::Migration
  def self.up
    create_table :nation_regions do |t|
      t.string :name
      t.text :description
      t.string :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :nation_regions
  end
end
