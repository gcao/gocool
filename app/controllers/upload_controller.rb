class UploadController < ApplicationController
  def index
    render :layout => false
  end
  
  def create
    @upload = Upload.create(params[:upload])
  end
end