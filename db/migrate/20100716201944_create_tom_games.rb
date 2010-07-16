class CreateTomGames < ActiveRecord::Migration
  def self.up
    create_table :tom_games do |t|
      t.string :name
      t.string :page_url
      t.string :sgf_url
    end
    
    add_index :tom_games, :page_url, :name => 'tom_games_page_url'
    add_index :tom_games, :sgf_url, :name => 'tom_games_sgf_url'
  end

  def self.down
    drop_table :tom_games
  end
end
