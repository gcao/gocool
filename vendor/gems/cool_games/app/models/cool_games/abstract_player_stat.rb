module CoolGames
  module AbstractPlayerStat
    def games
      games_as_black + games_as_white
    end

    def games_won
      games_won_as_black + games_won_as_white
    end

    def games_lost
      games_lost_as_black + games_lost_as_white
    end
  end
end
