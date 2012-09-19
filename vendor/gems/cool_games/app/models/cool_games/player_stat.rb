module CoolGames
  class PlayerStat
    include Mongoid::Document
    include Mongoid::Timestamps
    include AbstractPlayerStat

    embedded_in :player, class_name: 'CoolGames::Player', inverse_of: :stat

    field "games_as_black"     , type: Integer, default: 0
    field "games_won_as_black" , type: Integer, default: 0
    field "games_lost_as_black", type: Integer, default: 0
    field "games_as_white"     , type: Integer, default: 0
    field "games_won_as_white" , type: Integer, default: 0
    field "games_lost_as_white", type: Integer, default: 0
    field "updated_at"         , type: Date
  end
end
