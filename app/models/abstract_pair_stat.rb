module AbstractPairStat
  def self.included(klass)
    klass.extend AbstractPairStat::ClassMethods
  end
  
  module ClassMethods
    def find_or_create player_id, opponent_id
      find_by_player_id_and_opponent_id(player_id, opponent_id) || create!(:player_id => player_id, :opponent_id => opponent_id)
    end
  end
end
