class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :game_type
      t.string :status, :default => 'finished' # planned, finished, playing
      t.integer :rule # 1 - Chinese, 2 - Japanese, 3 - Korean, 4 - Ying
      t.string :rule_raw
      t.string :rule_raw
      t.integer :board_size
      t.integer :handicap
      t.integer :start_color
      t.float :komi
      t.string :komi_raw
      t.string :result
      t.integer :winner
      t.string :winner_raw
      t.integer :moves
      t.float :win_points
      t.string :name, :event, :place, :source, :program
      t.datetime :played_at
      t.string :played_at_raw
      t.string :time_rule
      t.boolean :is_online_game
      t.integer :gaming_platform_id
      t.text :description
      # player info
      t.integer :black_id, :white_id # player_id or online_player_id
      t.string :black_name, :black_rank, :white_name, :white_rank
      t.integer :primary_game_source_id
      t.string :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
