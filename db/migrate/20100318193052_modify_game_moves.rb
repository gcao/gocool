class ModifyGameMoves < ActiveRecord::Migration
  def self.up
    remove_column :game_moves, :ko
    add_column :game_moves, :serialized_board, :text
  end

  def self.down
  end
end
