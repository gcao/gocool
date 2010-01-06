class UploadSearchController < ApplicationController
  def index
    if params[:search_type] == 'description'
      description = params[:description].try(:strip)
      @uploads = Upload.with_description(description).paginate(page_params)
    end
  end
end
