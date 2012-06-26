class HomeController < ApplicationController
  helper 'cool_games/base', 'cool_games/widgets', 'cool_games/pagination'

  def index
    @users = User.all
  end
end
