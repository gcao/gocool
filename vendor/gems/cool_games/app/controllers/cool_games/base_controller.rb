module CoolGames
  class BaseController < ApplicationController
    include PaginationHelper

    helper "cool_games/urls", "cool_games/widgets", "cool_games/pagination"

    before_filter do
      @server2js = {}
      Thread.current[:user] = current_user
    end

    after_filter do
      Thread.current[:user] = nil
    end

    def current_player
      current_user.nil_or.player
    end
  end
end
