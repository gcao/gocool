class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :game_type # 0 - WEIQI, 1 - DAOQI
      t.integer :status # -1 - N/A(placeholder), 0 - finished, 1 - playing
      t.integer :rule # 0 - Chinese, 1 - Japanese, 3 - Korean, 4 - Ying
      t.integer :board_size, :handicap
      t.integer :first_color # 0 - black, 1 - white
      t.float :komi
      t.integer :result
      t.integer :winner # 0 - unknown, 1 - black, 2 - white, 3 - draw
      t.integer :moves
      t.float :win_points
      t.string :name, :event, :place, :source
      t.datetime :played_at
      t.boolean :is_online_game
      t.integer :platform_id
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
