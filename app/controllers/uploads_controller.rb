class UploadsController < ApplicationController
  layout proc{"upload"}

  def index
  end
  
  def create
    @upload = Upload.new(params[:upload])
    if @upload.valid?
      @upload.save!
      flash[:success] = t('upload.success')
    else
      if @upload.errors[:email]
        flash[:error] = t('upload.email_required')
      elsif @upload.errors[:upload_file_name]
        flash[:error] = t('upload.file_required')
      end
      render :action => :index
    end
  end
end