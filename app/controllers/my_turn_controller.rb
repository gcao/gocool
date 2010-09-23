class MyTurnController < ActionController::Metal
  include ActionController::Rendering

  def my_turn
    if Game.my_turn_by_name(request.params['player']).not_finished.count > 0
      render :text => "my_turn"
    elsif Game.by_name(request.params['player']).not_finished.count > 0
      render :text => "not_my_turn"
    else
      render :text => "no_game"
    end
  end
end