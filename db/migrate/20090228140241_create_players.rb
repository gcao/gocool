class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer :nation_region_id
      t.string :username, :first_name_en, :last_name_en, :full_name_en, :first_name_cn, :last_name_cn, :other_names
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
  end

  def self.down
    drop_table :players
  end
end
