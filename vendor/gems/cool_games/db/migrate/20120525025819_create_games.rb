class CreateGames < ActiveRecord::Migration
  def up
    create_table :cg_games do |t|
      t.integer :game_type
      t.string :state, :default => 'finished' # planned, finished, playing
      t.integer :rule # 1 - Chinese, 2 - Japanese, 3 - Korean, 4 - Ying
      t.string :rule_raw
      t.integer :board_size
      t.integer :handicap
      t.integer :start_side
      t.float :komi
      t.string :komi_raw
      t.string :result
      t.integer :winner
      t.integer :moves
      t.float :win_points
      t.string :name, :event, :place, :source, :program
      t.datetime :played_at
      t.string :played_at_raw
      t.string :time_rule
      t.boolean :is_online_game
      t.integer :gaming_platform_id
      t.text :description
      t.boolean :for_rating
      # player info
      t.integer :black_id, :white_id # player_id or online_player_id
      t.string :black_name, :black_rank, :white_name, :white_rank, :black_team, :white_team
      t.integer :primary_upload_id
      t.string :updated_by
      t.timestamps
    end

    add_index :cg_games, :gaming_platform_id, :name => 'games_platform_id'
    add_index :cg_games, [:gaming_platform_id, :black_id, :white_id], :name => 'games_platform_black_white'
    add_index :cg_games, :black_id, :name => 'games_black_id'
    add_index :cg_games, :white_id, :name => 'games_white_id'
  end

  def down
  end
end
