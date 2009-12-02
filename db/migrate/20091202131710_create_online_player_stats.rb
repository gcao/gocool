class CreateOnlinePlayerStats < ActiveRecord::Migration
  INCREMENT_SP_NAME = "increment_online_player_stats"
  DECREMENT_SP_NAME = "decrement_online_player_stats"

  INS_TRIGGER_NAME = "games_ins_trigger"
  UPD_TRIGGER_NAME = "games_upd_trigger"
  DEL_TRIGGER_NAME = "games_del_trigger"
  
  def self.up
    create_table :online_player_stats do |t|
      t.integer :online_player_id, :null => false
      t.integer :games_as_black, :default => 0
      t.integer :games_won_as_black, :default => 0
      t.integer :games_lost_as_black, :default => 0
      t.integer :games_as_white, :default => 0
      t.integer :games_won_as_white, :default => 0
      t.integer :games_lost_as_white, :default => 0
      t.datetime :first_game_played
      t.datetime :last_game_played
      t.timestamps
    end

    add_index :online_player_stats, :online_player_id, :unique => true

    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{INCREMENT_SP_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE #{INCREMENT_SP_NAME} (IN black_id INT, IN white_id INT, IN winner INT)
BEGIN
  DECLARE black_won, black_lost INT DEFAULT 0;
  DECLARE white_won, white_lost INT DEFAULT 0;

  IF winner = 1 THEN
    SET black_won  = 1;
    SET white_lost = 1;
  END IF;

  IF winner = 2 THEN
    SET black_lost = 1;
    SET white_won  = 1;
  END IF;

  if black_id > 0 THEN
    UPDATE online_player_stats SET
      games_as_black        = games_as_black + 1,
      games_won_as_black    = games_won_as_black + black_won,
      games_lost_as_black   = games_lost_as_black + black_lost
    WHERE online_player_id  = black_id;
  END IF;

  if white_id > 0 THEN
    UPDATE online_player_stats SET
      games_as_white        = games_as_white + 1,
      games_won_as_white    = games_won_as_white + white_won,
      games_lost_as_white   = games_lost_as_white + white_lost
    WHERE online_player_id  = white_id;
  END IF;
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
  END IF;

  IF winner = 2 THEN
    SET black_lost = 1;
    SET white_won  = 1;
  END IF;

  if black_id > 0 THEN
    UPDATE online_player_stats SET
      games_as_black        = games_as_black - 1,
      games_won_as_black    = games_won_as_black - black_won,
      games_lost_as_black   = games_lost_as_black - black_lost
    WHERE online_player_id  = black_id;
  END IF;

  if white_id > 0 THEN
    UPDATE online_player_stats SET
      games_as_white        = games_as_white - 1,
      games_won_as_white    = games_won_as_white - white_won,
      games_lost_as_white   = games_lost_as_white - white_lost
    WHERE online_player_id  = white_id;
  END IF;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP TRIGGER IF EXISTS #{INS_TRIGGER_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{INS_TRIGGER_NAME}
  AFTER INSERT ON games FOR EACH ROW
BEGIN
  CALL increment_online_player_stats(NEW.black_id, NEW.white_id, NEW.winner);
END
    SQL

    ActiveRecord::Base.connection.execute "DROP TRIGGER IF EXISTS #{UPD_TRIGGER_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{UPD_TRIGGER_NAME}
  BEFORE UPDATE ON games FOR EACH ROW
BEGIN
  CALL decrement_online_player_stats(OLD.black_id, OLD.white_id, OLD.winner);
  CALL increment_online_player_stats(NEW.black_id, NEW.white_id, NEW.winner);
END
    SQL

    ActiveRecord::Base.connection.execute "DROP TRIGGER IF EXISTS #{DEL_TRIGGER_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{DEL_TRIGGER_NAME}
  BEFORE DELETE ON games FOR EACH ROW
BEGIN
  CALL decrement_online_player_stats(OLD.black_id, OLD.white_id, OLD.winner);
END
    SQL
  end

  def self.down
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{INCREMENT_SP_NAME}"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{DECREMENT_SP_NAME}"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{INS_TRIGGER_NAME}"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{UPD_TRIGGER_NAME}"
    ActiveRecord::Base.connection.execute "DROP PROCEDURE IF EXISTS #{DEL_TRIGGER_NAME}"
    drop_table :online_player_stats
  end
end
