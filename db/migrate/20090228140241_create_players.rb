class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer :nation_region_id
      t.string :username, :last_name, :first_name, :chinese_name, :pinyin_name, :other_names
      t.boolean :is_amateur
      t.string :rank
      t.string :sex # male, female
      t.integer :birth_year
      t.date :birthday
      t.string :province_state, :city
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
