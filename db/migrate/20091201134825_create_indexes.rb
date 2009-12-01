class CreateIndexes < ActiveRecord::Migration
  def self.up
    add_index :games, :gaming_platform_id, :name => 'games_platform_id'
    add_index :games, [:gaming_platform_id, :black_id, :white_id], :name => 'games_platform_black_white'
    add_index :games, :black_id, :name => 'games_black_id'
    add_index :games, :white_id, :name => 'games_white_id'
  end

  def self.down
    remove_index :games, 'games_platform_id'
    remove_index :games, 'games_platform_black_white'
    remove_index :games, 'games_black_id'
    remove_index :games, 'games_white_id'
  end
end
