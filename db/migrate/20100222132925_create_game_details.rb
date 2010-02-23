class CreateGameDetails < ActiveRecord::Migration
  def self.up
    create_table :game_details do |t|
      t.integer :game_id
      t.string :handicaps
      t.integer :whose_turn
      t.integer :move_no
      t.string :last_move
      t.string :moves, :limit => 65000
      t.string :formatted_moves, :limit => 65000
    end

    add_index :game_details, :game_id, :name => 'game_details_game_id'
  end

  def self.down
  end
end
