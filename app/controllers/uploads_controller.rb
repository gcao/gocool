class UploadsController < ApplicationController
  layout "upload"

  def index
  end
  
  def create
    email = params[:upload][:email]
    files = process_upload_param(params[:upload][:upload])
    
    if files.is_a? Array
      @uploads = upload_multiple(email, files) 
      return
    end
    
    @upload = Upload.new(:email => email, :upload => files)
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
  
  def process_upload_param upload_param
    return upload_param unless upload_param.is_a? Array
    upload_param.reject!{|p| p.blank? }
    if upload_param.size == 1
      upload_param[0]
    elsif upload_param.size == 0
      nil
    else
      upload_param
    end
  end
  
  def upload_multiple email, files
    files.map {|file|
      upload = Upload.new(:email => email, :upload => file)
      if upload.valid?
        upload.save!
      end
      upload
    }
  end
end