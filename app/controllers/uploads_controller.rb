class UploadsController < ApplicationController
  layout "upload"

  def index
  end
  
  def create
    email = normalize_email(params[:upload][:email])
    files = extract_files params[:upload]
    
    session[:upload_email] = email
    
    if files.length == 1
      upload_single email, files[0]
    else
      upload_multiple email, files
    end
  end
  
  def show
    @upload = Upload.find(params[:id])
    render :text => 'Game not found', :status => '404' unless @upload
  end
  
  def search
    @uploads = Upload.find_all_by_email normalize_email(params[:email])
  end
  
  private
  
  def normalize_email email
    return if email.blank?
    email.strip.downcase
  end
  
  def extract_files params
    file_params = params.except(:email)
    return file_params.values
  end
  
  def upload_single email, file
    @upload = Upload.new(:email => email, :upload => file)
    if @upload.valid?
      @upload.save!
      save_game(@upload, parse(@upload))
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
  
  def upload_multiple email, files
    @uploads =  files.map {|file|
      upload = Upload.new(:email => email, :upload => file)
      if upload.valid?
        upload.save!
      end
      upload
    }
  end
  
  def parse upload
    SGF::Parser.parse_file(upload.upload.path)
  end
  
  def save_game upload, sgf_game
    game = Game.new
    game.load_parsed_game(sgf_game)
    game.save!
    
    game_data = GameData.new
    game_data.game = game
    game_data.source_type = GameData::SOURCE_UPLOAD
    game_data.upload_id = upload.id
    game_data.save!
  end
end