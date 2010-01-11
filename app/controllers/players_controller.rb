class PlayersController < ApplicationController
  def index
  end

  def search
    @platform = params[:platform]
    @name = params[:name]
    if @platform.blank?
      @players = Player.name_like(@name).paginate(page_params)
      render :partial => "players", :layout => false
    elsif @platform.strip == 'all'
      # TODO
    else
      @players = OnlinePlayer.search(@platform, @name).paginate(page_params)
      render :partial => "online_players", :layout => false
    end
  end
end
