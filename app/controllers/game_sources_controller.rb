class GameSourcesController < ApplicationController
  def show
    @game_source = GameSource.find(params[:id])
    
    respond_to do |format|
      format.html
      format.sgf  { render_sgf(@game_source) }
    end
  end
  
  private
  
  def render_sgf game_source
    case game_source.source_type
    when GameSource::PASTIE_TYPE
      render :text => game_source.data
    when GameSource::UPLOAD_TYPE
      response.headers['X-Sendfile'] = game_source.upload.upload.path
      render :nothing => true
    else
      raise 'TODO'
    end
  end
end