class UpdateStats < ActiveRecord::Migration
  RESET_PLAYER_STAT = "reset_player_stats"
  RESET_PAIR_STAT   = "reset_pair_stats"

  def self.up
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{RESET_PLAYER_STAT}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{RESET_PLAYER_STAT}()
BEGIN
  DECLARE _black_id, _white_id, _winner, end_of_cursor INT DEFAULT 0;
  DECLARE game_cursor CURSOR FOR
    SELECT black_id, white_id, winner FROM games;

  DECLARE CONTINUE HANDLER FOR NOT FOUND 
    SET end_of_cursor = 1;

  UPDATE player_stats SET games_as_black = 0, games_won_as_black = 0, games_lost_as_black = 0,
    games_as_white = 0, games_won_as_white = 0, games_lost_as_white = 0;

  OPEN game_cursor;

  WHILE end_of_cursor = 0 DO
    FETCH game_cursor INTO _black_id, _white_id, _winner;
    CALL increment_player_stats(_black_id, _white_id, _winner);
  END WHILE;

  CLOSE game_cursor;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{RESET_PAIR_STAT}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{RESET_PAIR_STAT}()
BEGIN
  DECLARE _black_id, _white_id, _winner, end_of_cursor INT DEFAULT 0;
  DECLARE game_cursor CURSOR FOR
    SELECT black_id, white_id, winner FROM games;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET end_of_cursor = 1;

  UPDATE pair_stats SET games_as_black = 0, games_won_as_black = 0, games_lost_as_black = 0,
    games_as_white = 0, games_won_as_white = 0, games_lost_as_white = 0;

  OPEN game_cursor;

  WHILE end_of_cursor = 0 DO
    FETCH game_cursor INTO _black_id, _white_id, _winner;
    CALL increment_pair_stats(_black_id, _white_id, _winner);
  END WHILE;

  CLOSE game_cursor;
END
    SQL
  end

  def self.down
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{RESET_PLAYER_STAT}"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{RESET_PAIR_STAT}"
  end
end
