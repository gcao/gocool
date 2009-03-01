class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :game_type, :default => 'weiqi' # weiqi, daoqi
      t.string :status, :default => 'finished' # planned, finished, playing
      t.integer :rule, :default => 1 # 1 - Chinese, 2 - Japanese, 3 - Korean, 4 - Ying
      t.integer :board_size, :handicap
      t.string :first_color, :default => 'black' # black, white
      t.float :komi
      t.string :result
      t.string :winner # black, white
      t.integer :moves
      t.float :win_points
      t.string :name, :event, :place, :source
      t.datetime :played_at
      t.boolean :is_online_game
      t.integer :gaming_platform_id
      t.text :description
      # player info
      t.integer :black_id, :white_id # player_id or online_player_id
      t.string :black_name, :black_rank, :white_name, :white_rank
      t.integer :game_data_id
      t.string :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
