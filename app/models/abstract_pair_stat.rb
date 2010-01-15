module AbstractPairStat
  def self.included(klass)
    klass.extend AbstractPairStat::ClassMethods
  end
  
  module ClassMethods
    def find_or_create player_id, opponent_id
      if player_id > opponent_id
        player_id, opponent_id = opponent_id, player_id
      elsif player_id == opponent_id
        raise "Player ID and opponent ID are the same: #{player_id}"
      end

      find_by_player_id_and_opponent_id(player_id, opponent_id) || create!(:player_id => player_id, :opponent_id => opponent_id)
    end
  end
end
