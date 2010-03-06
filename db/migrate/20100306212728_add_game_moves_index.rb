class AddGameMovesIndex < ActiveRecord::Migration
  def self.up
    
    add_index :game_moves, [:parent_id], :name => 'game_moves_parent_id'
  end

  def self.down
  end
end
