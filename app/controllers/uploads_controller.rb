class UploadsController < ApplicationController
  def index
  end
  
  def create
    @email = process_email(params[:upload] && params[:upload][:email])
    files = extract_files params[:upload]
    
    errors = validate(@email, files)
    unless errors.blank?
      flash[:error] = errors.join("<br/>")
      render :index
      return
    end
    
    @upload_results = Uploader.new.process @email, files
    if @upload_results.size == 1
      process_single_upload @upload_results.first
      return
    end
  end
  
  private
  
  def set_title
    @title = t('upload.page_title')
  end
  
  def validate email, files
    returning([]) do |errors|
      email_error = validate_email(email)
      errors << email_error if email_error
      errors << t('upload.file_required') if files.blank?
    end
  end
  
  def extract_files params
    return [] if params.nil?
    
    file_params = params.except(:email)
    return file_params.values
  end
  
  def process_single_upload upload_result
    case upload_result.status 
    when t('upload.status.success')
      flash[:success] = t('upload.success')
      @upload = upload_result.upload
      redirect_to game_source_url(@upload.game_source)
    when t('upload.status.already_uploaded')
      flash[:notice] = t('upload.game_found')
      redirect_to game_source_url(upload_result.existing_upload.game_source)
    when t('upload.status.validation_error')
      flash[:error] = t('upload.file_required')
      render :index
    when t('upload.status.error')
      flash[:error] = upload_result.detail
      render :index
    end
  end
end