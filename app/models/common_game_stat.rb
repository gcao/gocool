module CommonGameStat
  def find_or_create player_id, opponent_id
    if player_id > opponent_id
      player_id, opponent_id = opponent_id, player_id
    elsif player_id == opponent_id
      raise "Player and opponent ID are the same: #{player_id}"
    end

    find_by_player_id_and_opponent_id(player_id, opponent_id) || create!(:player_id => player_id, :opponent_id => opponent_id)
  end
end
