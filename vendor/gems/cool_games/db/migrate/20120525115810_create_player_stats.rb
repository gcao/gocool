class CreatePlayerStats < ActiveRecord::Migration
  def up
    create_table :cg_player_stats do |t|
      t.integer :player_id, :null => false
      t.integer :games_as_black, :default => 0
      t.integer :games_won_as_black, :default => 0
      t.integer :games_lost_as_black, :default => 0
      t.integer :games_as_white, :default => 0
      t.integer :games_won_as_white, :default => 0
      t.integer :games_lost_as_white, :default => 0
      t.datetime :first_game_played
      t.datetime :last_game_played
      t.timestamps
    end

    add_index :cg_player_stats, :player_id, :unique => true
  end

  def down
  end
end
