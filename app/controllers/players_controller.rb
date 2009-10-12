class PlayersController < ApplicationController
  def index
  end
  
  def search_online_players
    render :layout => false
  end
end