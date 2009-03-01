class CreateGameDatas < ActiveRecord::Migration
  def self.up
    create_table :game_datas do |t|
      t.integer :game_id
      t.string :format # sgf
      t.string :charset
      t.string :source_type # data, path, url
      t.text :data
      t.string :path
      t.string :url
      t.boolean :is_commented
      t.string :commented_by
      t.text :description
      t.string :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :game_datas
  end
end
