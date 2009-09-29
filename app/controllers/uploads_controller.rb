class UploadsController < ApplicationController
  layout "simple"

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
    
    if files.length == 1
      upload_single @email, files[0]
    else
      upload_multiple @email, files
    end
  end
  
  def show
    @upload = Upload.find(params[:id])
    render :text => t('upload.game_not_found'), :status => '404' unless @upload
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
  
  def upload_single email, file
    @upload = Upload.new(:email => email, :upload => file)
    if @upload.valid?
      @upload.save!
      
      process_duplicate_upload(@upload) and return
      
      @upload.save_game
      flash[:success] = t('upload.success')
      render :show
    else
      flash[:error] = t('upload.file_required')
      render :index
    end
  end
  
  def process_duplicate_upload upload
    upload.update_hash_code
    found_upload = Upload.with_hash(upload.hash_code).first
    if found_upload and found_upload.game_source
      upload.delete
      flash[:notice] = t('upload.game_found')
      redirect_to :controller => 'game_sources', :action => 'show', :id => found_upload.game_source.id
    end
  end
  
  def upload_multiple email, files
    raise "TODO"
    # @uploads =  files.map {|file|
    #   upload = Upload.new(:upload => file)
    #   if upload.valid?
    #     upload.save!
    #     save_game(email, upload, parse(upload))
    #   end
    #   upload
    # }
  end
  
  def rescue_action(e)
    if e.is_a? SGF::ParseError
      flash[:error] = e.to_s
      render :index
    elsif e.is_a? SGF::BinaryFileError
      flash[:error] = t('upload.is_binary_file')
      render :index
    else
      super
    end
  end
end