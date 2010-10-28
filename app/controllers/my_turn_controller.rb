class MyTurnController < ActionController::Metal
  def my_turn
    if Game.my_turn_by_name(request.params['player']).not_finished.count > 0
      self.response_body = "my_turn"
    elsif Game.by_name(request.params['player']).not_finished.count > 0
      self.response_body = "not_my_turn"
    else
      self.response_body = "no_game"
    end
  end
end