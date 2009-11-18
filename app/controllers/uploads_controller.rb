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

#    files = process_compressed_files(files)
    
    @upload_results = Uploader.new.process @email, files
    if @upload_results.size == 1
      process_single_upload @upload_results.first
      return
    end
  end
  
  private
  
  def validate email, files
    returning([]) do |errors|
      email_error = validate_email(email)
      errors << email_error if email_error
      errors << t('uploads.file_required') if files.blank?
    end
  end
  
  def extract_files params
    return [] if params.nil?
    
    file_params = params.except(:email)
    return file_params.values
  end

#  def process_compressed_files files
#    files.inject([]) do |result, file|
#      if compressed_file?(file)
#        logger.info file.inspect
#      else
#        result << file
#      end
#      result
#    end
#  end
  
  def process_single_upload upload_result
    case upload_result.status 
    when UploadResult::SUCCESS
      flash[:success] = t('uploads.success')
      @upload = upload_result.upload
      redirect_to game_source_url(@upload.game_source)
    when UploadResult::FOUND
      flash[:notice] = t('uploads.game_found')
      redirect_to game_source_url(upload_result.existing_upload.game_source)
    when UploadResult::VALIDATION_ERROR
      flash[:error] = t('uploads.file_required')
      render :index
    when UploadResult::ERROR
      flash[:error] = upload_result.detail
      render :index
    end
  end
end