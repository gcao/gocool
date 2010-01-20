class CreatePairStats < ActiveRecord::Migration
  INCREMENT_SP_NAME = "increment_pair_stats"
  DECREMENT_SP_NAME = "decrement_pair_stats"
  RESET_SP_NAME     = "reset_pair_stats"

  def self.up
    create_table :pair_stats do |t|
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

    add_index :pair_stats, [:player_id]
    add_index :pair_stats, [:opponent_id]
    add_index :pair_stats, [:player_id, :opponent_id], :unique => true


    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{INCREMENT_SP_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{INCREMENT_SP_NAME} (IN black_id INT, IN white_id INT, IN winner INT)
BEGIN
  DECLARE black_won, black_lost INT DEFAULT 0;
  DECLARE white_won, white_lost INT DEFAULT 0;

  IF winner = 1 THEN
    SET black_won  = 1;
    SET white_lost = 1;
  ELSEIF winner = 2 THEN
    SET black_lost = 1;
    SET white_won  = 1;
  END IF;

  UPDATE pair_stats SET
    games_as_black        = games_as_black + 1,
    games_won_as_black    = games_won_as_black + black_won,
    games_lost_as_black   = games_lost_as_black + black_lost
  WHERE player_id = black_id and opponent_id = white_id;

  UPDATE pair_stats SET
    games_as_white        = games_as_white + 1,
    games_won_as_white    = games_won_as_white + white_won,
    games_lost_as_white   = games_lost_as_white + white_lost
  WHERE player_id = white_id and opponent_id = black_id;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{DECREMENT_SP_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{DECREMENT_SP_NAME} (IN black_id INT, IN white_id INT, IN winner INT)
BEGIN
  DECLARE black_won, black_lost INT DEFAULT 0;
  DECLARE white_won, white_lost INT DEFAULT 0;

  IF winner = 1 THEN
    SET black_won  = 1;
    SET white_lost = 1;
  ELSEIF winner = 2 THEN
    SET black_lost = 1;
    SET white_won  = 1;
  END IF;

  UPDATE pair_stats SET
    games_as_black        = games_as_black - 1,
    games_won_as_black    = games_won_as_black - black_won,
    games_lost_as_black   = games_lost_as_black - black_lost
  WHERE player_id = black_id and opponent_id = white_id;

  UPDATE pair_stats SET
    games_as_white        = games_as_white - 1,
    games_won_as_white    = games_won_as_white - white_won,
    games_lost_as_white   = games_lost_as_white - white_lost
  WHERE player_id = white_id and opponent_id = black_id;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{RESET_SP_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{RESET_SP_NAME}()
BEGIN
  DECLARE _black_id, _white_id, _winner, end_of_cursor INT DEFAULT 0;
  DECLARE game_cursor CURSOR FOR
    SELECT black_id, white_id, winner FROM games WHERE gaming_platform_id = 0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET end_of_cursor = 1;

  UPDATE pair_stats SET games_as_black = 0, games_won_as_black = 0, games_lost_as_black = 0,
    games_as_white = 0, games_won_as_white = 0, games_lost_as_white = 0;

  OPEN game_cursor;

  WHILE end_of_cursor = 0 DO
    FETCH game_cursor INTO _black_id, _white_id, _winner;
    CALL #{INCREMENT_SP_NAME}(_black_id, _white_id, _winner);
  END WHILE;

  CLOSE game_cursor;
END
    SQL

  end

  def self.down
  end
end
