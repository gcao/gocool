class GameSourcesController < ApplicationController
  def index
  end

  def create
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
  
  def show
    @game_source = GameSource.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => 'simple' }
      format.sgf  { render_sgf(@game_source) }
    end
  end
  
  private
  
  def render_sgf game_source
    case game_source.source_type
    when GameSource::PASTIE_TYPE
      render :text => game_source.data
    when GameSource::UPLOAD_TYPE
      send_file game_source.upload.upload.path
    else
      raise 'TODO'
    end
  end

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
