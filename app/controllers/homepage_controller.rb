class HomepageController < ApplicationController
  def index
    @recent_game_sources = GameSource.recent.paginate(page_params)
  end
end