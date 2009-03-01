class CreateTournamentGames < ActiveRecord::Migration
  def self.up
    create_table :tournament_games do |t|
      t.integer :tournament_id, :game_id
      t.string :status # not_planned, not_started, started, finished
      t.string :result
      t.text :description
      t.integer :black_id, :white_id # link to tournament_players
      t.string :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_games
  end
end
