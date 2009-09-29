class HomeController < ApplicationController
  def index
    @recent_game_sources = GameSource.recent.paginate :page => ENV['ROWS_PER_PAGE'].to_i
  end
end