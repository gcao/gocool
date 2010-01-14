class ModifyGameTriggers < ActiveRecord::Migration
  INS_TRIGGER_NAME = "games_ins_trigger"
  UPD_TRIGGER_NAME = "games_upd_trigger"
  DEL_TRIGGER_NAME = "games_del_trigger"

  def self.up
    ActiveRecord::Base.connection.execute "DROP TRIGGER IF EXISTS #{INS_TRIGGER_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{INS_TRIGGER_NAME}
  AFTER INSERT ON games FOR EACH ROW
BEGIN
  IF NEW.gaming_platform_id > 0 THEN
    CALL increment_online_player_stats(NEW.black_id, NEW.white_id, NEW.winner);
    CALL increment_online_game_stats(NEW.black_id, NEW.white_id, NEW.winner);
  ELSE
    CALL increment_player_stats(NEW.black_id, NEW.white_id, NEW.winner);
    CALL increment_game_stats(NEW.black_id, NEW.white_id, NEW.winner);
  END IF;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP TRIGGER IF EXISTS #{UPD_TRIGGER_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{UPD_TRIGGER_NAME}
  BEFORE UPDATE ON games FOR EACH ROW
BEGIN
  IF OLD.black_id = NEW.black_id && OLD.white_id <> NEW.white_id THEN
    IF OLD.gaming_platform_id > 0 THEN
      CALL decrement_online_player_stats(0, OLD.white_id, OLD.winner);
      CALL decrement_online_game_stats(OLD.black_id, OLD.white_id, OLD.winner);
    ELSE
      CALL decrement_player_stats(0, OLD.white_id, OLD.winner);
      CALL decrement_game_stats(OLD.black_id, OLD.white_id, OLD.winner);
    END IF;

    IF NEW.gaming_platform_id > 0 THEN
      CALL increment_online_player_stats(0, NEW.white_id, NEW.winner);
      CALL increment_online_game_stats(NEW.black_id, NEW.white_id, NEW.winner);
    ELSE
      CALL increment_player_stats(0, NEW.white_id, NEW.winner);
      CALL increment_game_stats(NEW.black_id, NEW.white_id, NEW.winner);
    END IF;

  ELSEIF OLD.black_id <> NEW.black_id && OLD.white_id = NEW.white_id THEN
    IF OLD.gaming_platform_id > 0 THEN
      CALL decrement_online_player_stats(OLD.black_id, 0, OLD.winner);
      CALL decrement_online_game_stats(OLD.black_id, OLD.white_id, OLD.winner);
    ELSE
      CALL decrement_player_stats(OLD.black_id, 0, OLD.winner);
      CALL decrement_game_stats(OLD.black_id, OLD.white_id, OLD.winner);
    END IF;

    IF NEW.gaming_platform_id > 0 THEN
      CALL increment_online_player_stats(NEW.black_id, 0, NEW.winner);
      CALL increment_online_game_stats(NEW.black_id, NEW.white_id, NEW.winner);
    ELSE
      CALL increment_player_stats(NEW.black_id, 0, NEW.winner);
      CALL increment_game_stats(NEW.black_id, NEW.white_id, NEW.winner);
    END IF;

  ELSEIF OLD.black_id <> NEW.black_id && OLD.white_id <> NEW.white_id THEN
    IF OLD.gaming_platform_id > 0 THEN
      CALL decrement_online_player_stats(OLD.black_id, OLD.white_id, OLD.winner);
      CALL decrement_online_game_stats(OLD.black_id, OLD.white_id, OLD.winner);
    ELSE
      CALL decrement_player_stats(OLD.black_id, OLD.white_id, OLD.winner);
      CALL decrement_game_stats(OLD.black_id, OLD.white_id, OLD.winner);
    END IF;

    IF NEW.gaming_platform_id > 0 THEN
      CALL increment_online_player_stats(NEW.black_id, NEW.white_id, NEW.winner);
      CALL increment_online_game_stats(NEW.black_id, NEW.white_id, NEW.winner);
    ELSE
      CALL increment_player_stats(NEW.black_id, NEW.white_id, NEW.winner);
      CALL increment_game_stats(NEW.black_id, NEW.white_id, NEW.winner);
    END IF;
  END IF;
END
    SQL

    ActiveRecord::Base.connection.execute "DROP TRIGGER IF EXISTS #{DEL_TRIGGER_NAME}"
    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{DEL_TRIGGER_NAME}
  BEFORE DELETE ON games FOR EACH ROW
BEGIN
  IF OLD.gaming_platform_id > 0 THEN
    CALL decrement_online_player_stats(OLD.black_id, OLD.white_id, OLD.winner);
    CALL decrement_online_game_stats(OLD.black_id, OLD.white_id, OLD.winner);
  ELSE
    CALL decrement_player_stats(OLD.black_id, OLD.white_id, OLD.winner);
    CALL decrement_game_stats(OLD.black_id, OLD.white_id, OLD.winner);
  END IF;
END
    SQL
  end

  def self.down
  end
end
