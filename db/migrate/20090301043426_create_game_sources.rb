class CreateGameSources < ActiveRecord::Migration
  def self.up
    create_table :game_sources do |t|
      t.integer     :game_id
      t.string      :format # sgf
      t.string      :charset
      t.string      :source_type # data, path, url, upload
      t.string      :source
      t.text        :data
      t.references  :upload
      t.boolean     :is_commented
      t.string      :commented_by
      t.text        :description
      t.string      :hash_code
      t.string      :updated_by
      t.timestamps
    end
    
    add_index :game_sources, :game_id
    add_index :game_sources, :hash_code
  end

  def self.down
    drop_table :game_sources
  end
end
