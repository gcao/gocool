module GameInPlay
  def current_user_is_player?
    return unless logged_in?

    [black_id, white_id].include?(current_player.id)
  end

  def resign
    unless logged_in?
      raise "NOT LOGGED IN"
    end

    if current_player.id == black_id
      black_resign
      self.winner = WHITE
      self.result = "W+R"
    elsif current_player.id == white_id
      white_resign
      self.winner = BLACK
      self.result = "B+R"
    else
      raise "#{current_player.name} is not a player in game #{self.id}"
    end

    save!
  end
end
