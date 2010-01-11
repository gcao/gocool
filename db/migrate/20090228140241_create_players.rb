class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer :nation_region_id
      t.string :first_name_en, :last_name_en, :full_name_en
      t.string :first_name, :last_name, :full_name
      t.string :username, :other_names
      t.boolean :is_amateur
      t.string :rank
      t.string :sex # male, female
      t.integer :birth_year
      t.date :birthday
      t.string :birth_place
      t.string :website, :email
      t.text :description
      t.string :updated_by
      t.timestamps
    end

    add_index :players, :full_name, :name => 'players_full_name'
  end

  def self.down
    drop_table :players
  end
end
