class CreatePairStats < ActiveRecord::Migration
  def up
    create_table :cg_pair_stats do |t|
      t.integer :player_id, :null => false
      t.integer :opponent_id, :null => false
      t.integer :games_as_black, :default => 0
      t.integer :games_won_as_black, :default => 0
      t.integer :games_lost_as_black, :default => 0
      t.integer :games_as_white, :default => 0
      t.integer :games_won_as_white, :default => 0
      t.integer :games_lost_as_white, :default => 0
      t.timestamps
    end

    add_index :cg_pair_stats, [:player_id]
    add_index :cg_pair_stats, [:opponent_id]
    add_index :cg_pair_stats, [:player_id, :opponent_id], :unique => true
  end

  def down
  end
end
