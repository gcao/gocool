class GamesController < ApplicationController
  def index
    if params[:commit] == t('form.search_button')
      @games = Game.search(params[:platform], params[:first_player], params[:second_player])
    end
  end
end
