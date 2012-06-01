module CoolGames
  class UploadsController < BaseController
    include ParseErrorHelper

    UPLOAD_FILE = 'file'
    UPLOAD_SGF  = 'sgf'
    UPLOAD_URL  = 'url'

    def index
    end

    def create
      @description = params[:upload_description]
      @upload_type = params[:upload_type]

      case @upload_type
        when UPLOAD_FILE then process_files
        when UPLOAD_SGF  then process_sgf
        when UPLOAD_URL  then process_url
      end
    end

    def show
      @upload = Upload.find(params[:id])

      respond_to do |format|
        format.html { redirect_to :controller => :games, :action => :show, :id => @upload.game_id }
        format.sgf  { send_file(@upload.file.path) }
      end
    end

    private

    def process_files
      files = params[:upload].values

      if files.length == 0
        flash.now[:error] = "TODO"
        return
      end

      @upload_results = Uploader.new.process_files @description, files
      if @upload_results.size == 1
        process_single_upload @upload_results.first
        return
      end
    end

    def process_single_upload upload_result
      case upload_result.status
      when UploadResult::SUCCESS
        flash.now[:success] = t('uploads.success')
        @upload = upload_result.upload
        redirect_to upload_url(@upload)
      when UploadResult::FOUND
        flash.now[:notice] = t('uploads.game_found')
        @upload = upload_result.found_upload
        redirect_to upload_url(@upload)
      when UploadResult::VALIDATION_ERROR
        flash.now[:error] = t('uploads.file_required')
        render :index
      when UploadResult::ERROR
        flash.now[:error] = upload_result.detail
        render :index
      end
    end

    def process_sgf
      data = params[:upload][:data]
      if error = validate_sgf(data)
        flash.now[:error] = error
        render :index
        return
      end

      hash_code = Gocool::Md5.string_to_md5 data
      if @upload = Upload.with_hash(hash_code).first
        flash.now[:notice] = t('uploads.game_found')
      else
        @upload = Upload.create_from_sgf @description, data, @sgf_game, hash_code
        flash.now[:success] = t('uploads.success')
      end

      redirect_to game_url(@upload.game_id)
    end

    def process_url
      url = params[:upload][:url]

      hash_code = Gocool::Md5.string_to_md5 url
      if @upload = Upload.with_hash(hash_code).first
        flash.now[:notice] = t('uploads.game_found')
      else
        @upload = Upload.create_from_url @description, url, hash_code
        flash.now[:success] = t('uploads.success')
      end

      redirect_to game_url(@upload.game_id)
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
end
