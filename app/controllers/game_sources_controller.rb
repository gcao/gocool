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
      format.sgf  { send_file(@game_source.upload.path) }
    end
  end
  
  private

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
end
