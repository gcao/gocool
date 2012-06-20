class CoolGames::BaseController < ApplicationController

  helper "cool_games/urls", "cool_games/widgets"

  before_filter do
    Thread.current[:user] = current_user
  end

  after_filter do
    Thread.current[:user] = nil
  end

  def current_player
    current_user.nil_or.player
  end
end
