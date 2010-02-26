class CreateGameDetails < ActiveRecord::Migration
  def self.up
    create_table :game_details do |t|
      t.integer :game_id
      t.integer :whose_turn
      t.datetime :last_move_time
      t.string :handicaps
      t.string :formatted_moves, :limit => 4000
    end

    add_index :game_details, :game_id, :name => 'game_details_game_id'
  end

  def self.down
  end
end
