# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Discuz::Authentication
  # include ExceptionNotifiable if RAILS_ENV=='production'

  include GamesWidgetHelper, UploadsWidgetHelper, PlayersWidgetHelper, PlayersWidgetHelper, OpponentsWidgetHelper

  helper :urls, :games_widget, :uploads_widget, :players_widget, :player_widget, :opponents_widget
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  if ENV['INTEGRATE_WITH_FORUM'] == 'true'
    layout 'application_integrated'
    before_filter :authenticate_via_bbs
  end
  
  before_filter :set_title_and_header
  before_filter :set_locale

  protected
  
  def set_title_and_header
    @page_title = t('shared.page_title') + " - " + t("#{params[:controller]}.page_title")
    @page_header = t("#{params[:controller]}.page_header")
  end
  
  def set_locale
    I18n.locale = @locale = params[:locale] || cookies[:gocool_locale] || ENV['DEFAULT_LOCALE']
    cookies[:gocool_locale] = {:value => @locale, :expires => 100.years.from_now }
  end
  
  def send_file file
    if ENV["USE_XSENDFILE"] == "true"
      response.headers['X-Sendfile'] = file
      render :nothing => true
    else
      render :file => file
    end
  end

  def page_params page_no_param = :page
    page_size = (ENV['ROWS_PER_PAGE'] || 15).to_i
    { :per_page => page_size, :page => params[page_no_param] }
  end
  helper_method :page_params

  def authenticate_via_bbs
    login_check
    if forum_session = request.env['forum_session']
      Thread.current[:user] = @user = User.find_or_create(:user_type => User::DISCUZ_USER, :external_id => forum_session.uid, :username => forum_session.username)
    end
  end
end
