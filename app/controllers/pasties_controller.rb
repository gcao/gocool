class PastiesController < ApplicationController
  include ParseErrorHelper

  layout "simple"
  
  def create
    email = process_email(params[:pastie] && params[:pastie][:email])
    data = params[:pastie] && params[:pastie][:data]
    
    errors = validate(email, data)
    unless errors.blank?
      flash[:error] = errors.join("<br/>")
      render :index
      return
    end

    @game = Game.new
    @game.load_parsed_game(@sgf_game)
    @game.save!

    @game_source = GameSource.new(:game => @game, :source => params[:pastie][:email], :data => params[:pastie][:data])
    @game_source.save!
    flash[:success] = t('pastie.success')
    render :show
  end

  private
  
  def validate email, data
    returning([]) do |errors|
      email_error = validate_email(email)
      errors << email_error if email_error
      if data.blank?
        errors << t('pastie.data_required') 
      else
        begin
          @sgf_game = SGF::Parser.parse data
        rescue => e
          errors << t('pastie.data_invalid_parse_error') + convert_parse_error_to_html(e)
        end
      end
    end
  end
  
end