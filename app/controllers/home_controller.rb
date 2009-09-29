class HomeController < ApplicationController
  def index
    @recent_game_sources = GameSource.recent
  end
end