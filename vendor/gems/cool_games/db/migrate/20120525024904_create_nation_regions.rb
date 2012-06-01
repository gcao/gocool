class CreateNationRegions < ActiveRecord::Migration
  def up
    create_table :cg_nation_regions do |t|
      t.string :name
      t.text :description
      t.string :updated_by
      t.timestamps
    end
  end

  def down
  end
end
