module CoolGames
  class PlayerStat < ActiveRecord::Base
    include AbstractPlayerStat

    set_table_name "cg_player_stats"
  end
end
