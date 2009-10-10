class HomeController < ApplicationController
  def index
    @recent_game_sources = GameSource.recent.paginate :per_page => ENV['ROWS_PER_PAGE'].to_i, :page => params[:page]
  end
end