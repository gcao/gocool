class ModifyGameMoves < ActiveRecord::Migration
  def self.up
    remove_column :game_moves, :ko
    add_column :game_moves, :serialized_board, :string, :limit => 65000
  end

  def self.down
  end
end
