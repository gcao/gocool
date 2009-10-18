class CreateOnlinePlayerViews < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute <<-SQL
      create or replace view online_player_games as
      select online_players.id as online_player_id, count(*) as games 
      from games
      left join online_players 
      on games.gaming_platform_id = online_players.gaming_platform_id and 
      (games.black_id = online_players.id or games.white_id = online_players.id)
      group by online_players.id;
    SQL
    ActiveRecord::Base.connection.execute <<-SQL
      create or replace view online_player_won_games as
      select online_players.id as online_player_id, count(games.id) as games 
      from online_players 
      left join games on games.gaming_platform_id = online_players.gaming_platform_id and 
      ((games.winner = 1 and games.black_id = online_players.id) or (games.winner = 2 and games.white_id = online_players.id))
      group by online_players.id;
    SQL
    ActiveRecord::Base.connection.execute <<-SQL
      create or replace view online_player_lost_games as
      select online_players.id as online_player_id, count(games.id) as games 
      from online_players
      left join games on games.gaming_platform_id = online_players.gaming_platform_id and 
      ((games.winner = 2 and games.black_id = online_players.id) or (games.winner = 1 and games.white_id = online_players.id))
      group by online_players.id;
    SQL
  end

  def self.down
    ActiveRecord::Base.connection.execute <<-SQL
      DROP VIEW IF EXISTS online_player_games
    SQL
    ActiveRecord::Base.connection.execute <<-SQL
      DROP VIEW IF EXISTS online_player_won_games
    SQL
    ActiveRecord::Base.connection.execute <<-SQL
      DROP VIEW IF EXISTS online_player_lost_games
    SQL
  end
end
