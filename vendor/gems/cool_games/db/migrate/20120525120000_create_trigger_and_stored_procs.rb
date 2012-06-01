class CreateTriggerAndStoredProcs < ActiveRecord::Migration
  INS_GAMES_TRIGGER      = "cg_games_ins_trigger"
  UPD_GAMES_TRIGGER      = "cg_games_upd_trigger"
  DEL_GAMES_TRIGGER      = "cg_games_del_trigger"
  INCREMENT_PLAYER_STATS = "cg_increment_player_stats"
  DECREMENT_PLAYER_STATS = "cg_decrement_player_stats"
  RESET_PLAYER_STATS     = "cg_reset_player_stats"
  INCREMENT_PAIR_STATS   = "cg_increment_pair_stats"
  DECREMENT_PAIR_STATS   = "cg_decrement_pair_stats"
  RESET_PAIR_STATS       = "cg_reset_pair_stats"

  def up
    ActiveRecord::Base.connection.execute "DROP TRIGGER IF EXISTS #{INS_GAMES_TRIGGER}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{INS_GAMES_TRIGGER}
  AFTER INSERT ON cg_games FOR EACH ROW
BEGIN
  CALL #{INCREMENT_PLAYER_STATS}(NEW.black_id, NEW.white_id, NEW.winner);
  CALL #{INCREMENT_PAIR_STATS}(NEW.black_id, NEW.white_id, NEW.winner);
END
    SQL

    ActiveRecord::Base.connection.execute "DROP TRIGGER IF EXISTS #{UPD_GAMES_TRIGGER}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{UPD_GAMES_TRIGGER}
  BEFORE UPDATE ON cg_games FOR EACH ROW
BEGIN
  IF OLD.black_id <> NEW.black_id || OLD.white_id <> NEW.white_id || OLD.winner <> NEW.winner THEN
    CALL #{DECREMENT_PLAYER_STATS}(OLD.black_id, OLD.white_id, OLD.winner);
    CALL #{DECREMENT_PAIR_STATS}(OLD.black_id, OLD.white_id, OLD.winner);

    CALL #{INCREMENT_PLAYER_STATS}(NEW.black_id, NEW.white_id, NEW.winner);
    CALL #{INCREMENT_PAIR_STATS}(NEW.black_id, NEW.white_id, NEW.winner);
  END IF;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP TRIGGER IF EXISTS #{DEL_GAMES_TRIGGER}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{DEL_GAMES_TRIGGER}
  BEFORE DELETE ON cg_games FOR EACH ROW
BEGIN
  CALL #{DECREMENT_PLAYER_STATS}(OLD.black_id, OLD.white_id, OLD.winner);
  CALL #{DECREMENT_PAIR_STATS}(OLD.black_id, OLD.white_id, OLD.winner);
END
    SQL

    # player_stats stored procedures
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{INCREMENT_PLAYER_STATS}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{INCREMENT_PLAYER_STATS} (IN black_id INT, IN white_id INT, IN winner INT)
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

  if black_id > 0 THEN
    UPDATE cg_player_stats SET
      games_as_black        = games_as_black + 1,
      games_won_as_black    = games_won_as_black + black_won,
      games_lost_as_black   = games_lost_as_black + black_lost
    WHERE player_id  = black_id;
  END IF;

  if white_id > 0 THEN
    UPDATE cg_player_stats SET
      games_as_white        = games_as_white + 1,
      games_won_as_white    = games_won_as_white + white_won,
      games_lost_as_white   = games_lost_as_white + white_lost
    WHERE player_id  = white_id;
  END IF;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{DECREMENT_PLAYER_STATS}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{DECREMENT_PLAYER_STATS} (IN black_id INT, IN white_id INT, IN winner INT)
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

  if black_id > 0 THEN
    UPDATE cg_player_stats SET
      games_as_black        = games_as_black - 1,
      games_won_as_black    = games_won_as_black - black_won,
      games_lost_as_black   = games_lost_as_black - black_lost
    WHERE player_id  = black_id;
  END IF;

  if white_id > 0 THEN
    UPDATE cg_player_stats SET
      games_as_white        = games_as_white - 1,
      games_won_as_white    = games_won_as_white - white_won,
      games_lost_as_white   = games_lost_as_white - white_lost
    WHERE player_id  = white_id;
  END IF;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{RESET_PLAYER_STATS}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{RESET_PLAYER_STATS}()
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

    # pair_stats stored procedures
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{INCREMENT_PAIR_STATS}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{INCREMENT_PAIR_STATS} (IN black_id INT, IN white_id INT, IN winner INT)
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

  UPDATE cg_pair_stats SET
    games_as_black        = games_as_black + 1,
    games_won_as_black    = games_won_as_black + black_won,
    games_lost_as_black   = games_lost_as_black + black_lost
  WHERE player_id = black_id and opponent_id = white_id;

  UPDATE cg_pair_stats SET
    games_as_white        = games_as_white + 1,
    games_won_as_white    = games_won_as_white + white_won,
    games_lost_as_white   = games_lost_as_white + white_lost
  WHERE player_id = white_id and opponent_id = black_id;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{DECREMENT_PAIR_STATS}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{DECREMENT_PAIR_STATS} (IN black_id INT, IN white_id INT, IN winner INT)
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

  UPDATE cg_pair_stats SET
    games_as_black        = games_as_black - 1,
    games_won_as_black    = games_won_as_black - black_won,
    games_lost_as_black   = games_lost_as_black - black_lost
  WHERE player_id = black_id and opponent_id = white_id;

  UPDATE cg_pair_stats SET
    games_as_white        = games_as_white - 1,
    games_won_as_white    = games_won_as_white - white_won,
    games_lost_as_white   = games_lost_as_white - white_lost
  WHERE player_id = white_id and opponent_id = black_id;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{RESET_PAIR_STATS}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{RESET_PAIR_STATS}()
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

  def down
  end
end
