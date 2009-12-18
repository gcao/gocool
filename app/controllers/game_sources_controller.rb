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
      redirect_to game_source_url(@game_source = upload_result.game_source)
    when UploadResult::FOUND
      flash[:notice] = t('uploads.game_found')
      redirect_to game_source_url(upload_result.found_game_source)
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

    @game_source = GameSource.create_from_sgf data, @sgf_game

    flash[:success] = t('uploads.success')
    render :show
  end

  def process_url
    url = params[:upload][:url]
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
