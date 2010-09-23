class Admin::GamesController < ApplicationController
  def edit
    @formtastic = true
    @game = Game.find(params[:id])
  end
end
