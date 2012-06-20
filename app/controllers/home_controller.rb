class HomeController < ApplicationController
  helper 'cool_games/base', 'cool_games/widgets'

  def index
    @users = User.all
  end
end
