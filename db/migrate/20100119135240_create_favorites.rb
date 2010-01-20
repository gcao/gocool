class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites do |t|
      t.string :description
      t.integer :user_id, :null => false
      t.integer :favorite_type, :null => false
      t.integer :external_id
      t.integer :external_id2
      t.text :options
      t.timestamps
    end

    add_index :favorites, [:user_id]
    add_index :favorites, [:user_id, :favorite_type]
  end

  def self.down
  end
end
