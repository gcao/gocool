class PastiesController < ApplicationController
  layout "simple"
  
  def create
    @game_data = GameData.new(:source => params[:pastie][:email], :data => params[:pastie][:data])
    if @game_data.valid?
      @game_data.save!
      flash[:success] = t('pastie.success')
      render :show
    end
  end
end