class CreateGameDetails < ActiveRecord::Migration
  def up
    create_table :cg_game_details do |t|
      t.integer :game_id
      t.integer :whose_turn
      t.datetime :last_move_time
      t.text :formatted_moves
      t.integer :first_move_id
      t.integer :last_move_id
      t.string :setup_points
      t.timestamps
    end

    add_index :cg_game_details, :game_id, :name => 'game_details_game_id'
  end

  def down
  end
end
