class MergePlayers < ActiveRecord::Migration
  INS_TRIGGER_NAME = "games_ins_trigger"
  UPD_TRIGGER_NAME = "games_upd_trigger"
  DEL_TRIGGER_NAME = "games_del_trigger"

  def self.up
    add_column :players, :parent_id, :integer
    add_column :players, :gaming_platform_id, :integer
    add_column :players, :temp_id, :integer
    add_column :players, :registered_at, :datetime
    remove_column :players, :username
    rename_column :players, :full_name, :name

    ActiveRecord::Base.connection.execute <<-SQL
      insert into players(temp_id, gaming_platform_id, name)
      select id, gaming_platform_id, username from online_players
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
      insert into player_stats(player_id, games_as_black, games_won_as_black, games_lost_as_black,
        games_as_white, games_won_as_white, games_lost_as_white)
      select p.id, s.games_as_black, s.games_won_as_black, s.games_lost_as_black,
        s.games_as_white, s.games_won_as_white, s.games_lost_as_white
      from players p, online_player_stats s
      where p.temp_id = s.online_player_id
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
      DROP TRIGGER IF EXISTS #{INS_TRIGGER_NAME}
    SQL
    ActiveRecord::Base.connection.execute <<-SQL
      DROP TRIGGER IF EXISTS #{UPD_TRIGGER_NAME}
    SQL
    ActiveRecord::Base.connection.execute <<-SQL
      DROP TRIGGER IF EXISTS #{DEL_TRIGGER_NAME}
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
      update games set black_id = (
        select id from players
        where games.gaming_platform_id is not null
              and games.black_id = players.temp_id
      )
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
      update games set white_id = (
        select id from players
        where games.gaming_platform_id is not null
              and games.white_id = players.temp_id
      )
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{INS_TRIGGER_NAME}
  AFTER INSERT ON games FOR EACH ROW
BEGIN
  CALL increment_player_stats(NEW.black_id, NEW.white_id, NEW.winner);
  CALL increment_pair_stats(NEW.black_id, NEW.white_id, NEW.winner);
END
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{UPD_TRIGGER_NAME}
  BEFORE UPDATE ON games FOR EACH ROW
BEGIN
  IF OLD.black_id <> NEW.black_id || OLD.white_id <> NEW.white_id || OLD.winner <> NEW.winner THEN
    CALL decrement_player_stats(OLD.black_id, OLD.white_id, OLD.winner);
    CALL decrement_pair_stats(OLD.black_id, OLD.white_id, OLD.winner);

    CALL increment_player_stats(NEW.black_id, NEW.white_id, NEW.winner);
    CALL increment_pair_stats(NEW.black_id, NEW.white_id, NEW.winner);
  END IF;
END
    SQL

    ActiveRecord::Base.connection.execute <<-SQL
CREATE TRIGGER #{DEL_TRIGGER_NAME}
  BEFORE DELETE ON games FOR EACH ROW
BEGIN
  CALL decrement_player_stats(OLD.black_id, OLD.white_id, OLD.winner);
  CALL decrement_pair_stats(OLD.black_id, OLD.white_id, OLD.winner);
END
    SQL
  end

  def self.down
  end
end
