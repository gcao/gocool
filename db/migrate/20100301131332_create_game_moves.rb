class CreateGameMoves < ActiveRecord::Migration
  def self.up
    create_table :game_moves do |t|
      t.integer :game_detail_id, :null => false
      t.integer :player_id
      t.integer :move_no, :null => false
      t.integer :color, :null => false
      t.integer :x, :null => false
      t.integer :y, :null => false
      t.string  :dead # json [[1,2], [1,3]]
      t.boolean :ko
      t.integer :guess_player_id
      t.datetime :played_at
      # fields for awesome_nested_set
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
    end

    add_index :game_moves, [:game_detail_id], :name => 'game_moves_detail_id'
    add_index :game_moves, [:guess_player_id], :name => 'game_moves_guess_player_id'

    add_column :game_details, :first_move_id, :integer
    add_column :game_details, :last_move_id, :integer
  end

  def self.down
  end
end
