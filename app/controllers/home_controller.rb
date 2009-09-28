class HomeController < ApplicationController
  layout 'simple'
  
  def index
    @recent_game_sources = GameSource.recent
  end
end