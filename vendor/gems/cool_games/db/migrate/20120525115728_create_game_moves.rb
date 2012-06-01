class CreateGameMoves < ActiveRecord::Migration
  def up
    create_table :cg_game_moves do |t|
      t.integer :game_detail_id, :null => false
      t.integer :player_id
      t.integer :move_no, :null => false
      t.integer :color, :null => false
      t.integer :x, :null => false
      t.integer :y, :null => false
      t.string  :dead # json [[1,2], [1,3]]
      t.integer :guess_player_id
      t.datetime :played_at
      t.integer :parent_id
      t.string :setup_points
      t.text :serialized_board
      t.timestamps
    end

    add_index :cg_game_moves, [:game_detail_id], :name => 'game_moves_detail_id'
    add_index :cg_game_moves, [:guess_player_id], :name => 'game_moves_guess_player_id'
    add_index :cg_game_moves, [:parent_id], :name => 'game_moves_parent_id'
  end

  def down
  end
end
