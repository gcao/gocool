class UploadSearchController < ApplicationController
  def index
    if params[:search_type] == 'description'
      @uploads = Upload.find_by_description("%#{params[:description].try(:strip)}%")
    end
  end
end
