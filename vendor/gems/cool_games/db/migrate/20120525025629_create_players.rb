class CreatePlayers < ActiveRecord::Migration
  def up
    create_table :cg_players do |t|
      t.integer :nation_region_id
      t.string :first_name, :last_name, :name
      t.boolean :is_amateur
      t.string :rank
      t.string :sex # male, female
      t.integer :birth_year
      t.date :birthday
      t.string :birth_place
      t.string :website, :email
      t.text :description
      t.integer :parent_id
      t.integer :gaming_platform_id
      t.datetime :registered_at
      t.string :updated_by
      t.timestamps
    end

    add_index :cg_players, :name, :name => 'cg_players_name'
  end

  def down
  end
end
