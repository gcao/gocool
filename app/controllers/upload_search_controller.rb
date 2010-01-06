class UploadSearchController < ApplicationController
  def index
    if search_by_description?
      @description = params[:description].try(:strip)
      @uploads = Upload.with_description(@description).paginate(page_params)
    end
  end

  def search_by_description?
    params[:search_type] == 'description'
  end

  def search_by_date?
    params[:search_type] == 'date'
  end
  
  helper_method :search_by_description?, :search_by_date?
end
