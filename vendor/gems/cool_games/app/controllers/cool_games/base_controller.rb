class CoolGames::BaseController < ApplicationController

  helper :"cool_games/urls"
  helper :"cool_games/widgets"

  before_filter do
    Thread.current[:user] = current_user
  end

  after_filter do
    Thread.current[:user] = nil
  end

  def page_params page_no_param = :page
    page_size = (ENV['ROWS_PER_PAGE'] || 15).to_i
    { :per_page => page_size, :page => params[page_no_param] }
  end
  helper_method :page_params

  def current_player
    current_user.nil_or.player
  end
end
