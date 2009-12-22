class GameSourcesController < ApplicationController
  include ParseErrorHelper
  
  UPLOAD_FILE = 'file'
  UPLOAD_SGF  = 'sgf'
  UPLOAD_URL  = 'url'

  def index
  end

  def create
    @upload_type = params[:upload_type]

    case @upload_type
      when UPLOAD_FILE then process_files
      when UPLOAD_SGF  then process_sgf
      when UPLOAD_URL  then process_url
    end
  end
  
  def show
    @game_source = GameSource.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => 'simple' }
      format.sgf  { send_file(@game_source.upload.path) }
    end
  end
  
  private

  def process_files
    files = params[:upload].values

    if files.length == 0
      flash[:error] = "TODO"
      return
    end

    @upload_results = Uploader.new.process_files files
    if @upload_results.size == 1
      process_single_upload @upload_results.first
      return
    end
  end

  def process_single_upload upload_result
    case upload_result.status
    when UploadResult::SUCCESS
      flash[:success] = t('uploads.success')
      @game_source = upload_result.game_source
      render :show, :layout => "simple"
    when UploadResult::FOUND
      flash[:notice] = t('uploads.game_found')
      @game_source = upload_result.found_game_source
      render :show, :layout => "simple"
    when UploadResult::VALIDATION_ERROR
      flash[:error] = t('uploads.file_required')
      render :index
    when UploadResult::ERROR
      flash[:error] = upload_result.detail
      render :index
    end
  end

  def process_sgf
    data = params[:upload][:data]
    if error = validate_sgf(data)
      flash[:error] = error
      render :index
      return
    end

    hash_code = Gocool::Md5.string_to_md5 data
    if @game_source = GameSource.with_hash(hash_code).first
      flash[:notice] = t('uploads.game_found')
    else
      @game_source = GameSource.create_from_sgf data, @sgf_game, hash_code
      flash[:success] = t('uploads.success')
    end

    render :show, :layout => "simple"
  end

  def process_url
    url = params[:upload][:url]

    hash_code = Gocool::Md5.string_to_md5 url
    if @game_source = GameSource.with_url_hash(hash_code).first
      flash[:notice] = t('uploads.game_found')
    else
      @game_source = GameSource.create_from_url url, hash_code
      flash[:success] = t('uploads.success')
    end

    render :show, :layout => "simple"
  end

  def validate_sgf data
    if data.blank?
      t('uploads.data_required')
    else
      begin
        @sgf_game = SGF::Parser.parse data
        nil
      rescue => e
        t('uploads.data_invalid_parse_error') + convert_parse_error_to_html(e)
      end
    end
  end
end
