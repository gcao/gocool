module CoolGames
  module Api
    class BaseController < ActionController::Base
      include CoolGames::BaseHelper, BaseHelper
      helper 'cool_games/base'
    end
  end
end

