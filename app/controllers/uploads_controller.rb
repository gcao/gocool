class UploadsController < ApplicationController
  layout proc{"upload"}

  def index
  end
  
  def create
    upload_multiple and return if params[:upload][:upload].length > 1
    @upload = Upload.new(params[:upload])
    if @upload.valid?
      @upload.save!
      flash[:success] = t('upload.success')
      render :show
    else
      if @upload.errors[:email]
        flash[:error] = t('upload.email_required')
      elsif @upload.errors[:upload_file_name]
        flash[:error] = t('upload.file_required')
      end
      render :index
    end
  end
  
  def show
    @upload = Upload.find(params[:id])
    render :text => 'Game not found', :status => '404' unless @upload
  end
  
  private
  
  def upload_multiple
    uploads = params[:upload][:upload].map {|file|
      Upload.new(:email => params[:upload][:email], :upload => file)
    }
  end
end