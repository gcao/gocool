module CoolGames
  class PairStat
    include Mongoid::Document
    include Mongoid::Timestamps

    embedded_in :player  , class_name: 'CoolGames::Player', inverse_of: :opponents
    belongs_to  :opponent, class_name: "CoolGames::Player"

    field "games_as_black"     , type: Integer, default: 0
    field "games_won_as_black" , type: Integer, default: 0
    field "games_lost_as_black", type: Integer, default: 0
    field "games_as_white"     , type: Integer, default: 0
    field "games_won_as_white" , type: Integer, default: 0
    field "games_lost_as_white", type: Integer, default: 0

    #default_scope :include => 'opponent'

    #scope :opponent_name_like, lambda{ |name|
    #  { :conditions => ["name like ?", name] }
    #}

    #scope :sort_by_opponent_name, joins(:opponent).order(:name)

    def self.find_or_create player_id, opponent_id
      find_by_player_id_and_opponent_id(player_id, opponent_id) || create!(:player_id => player_id, :opponent_id => opponent_id)
    end

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
