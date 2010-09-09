# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ThreadGlobals
  include DiscuzInt::Authentication
  include GamesWidgetHelper, UploadsWidgetHelper, PlayerWidgetHelper, PlayersWidgetHelper, OpponentsWidgetHelper

  helper :urls, :games_widget, :uploads_widget, :players_widget, :player_widget, :opponents_widget
  
  protect_from_forgery

  before_filter :authenticate_via_bbs if ENV['INTEGRATE_WITH_FORUM'] == 'true'
  before_filter :admin_required, :only => [:edit, :update, :destroy]
  before_filter :set_title_and_header

  def is_admin?
     RAILS_ENV == 'development' or @current_user.nil_or.admin?
  end
  helper_method :logged_in?, :is_admin?

  def admin_required
    unless is_admin?
      logger.warn "Unauthorized operation by '#{@current_user.nil_or.username}' from #{user_ip_address}"
      render 'shared/admin_required'
    end
  end

  protected
  
  def set_title_and_header
    @page_title = t('shared.page_title') + " - " + t("#{params[:controller]}.page_title")
    @page_header = t("#{params[:controller]}.page_header")
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
    if logged_in?
      Thread.current[:user] = @current_user = User.find_or_load(login_session.username)
    else
      Thread.current[:user] = @current_user = nil
    end
  end

  def user_ip_address
    @user_ip_address ||= (request.env['HTTP_X_FORWARDED_FOR'].to_s.split(',').first || request.remote_addr)
  end

  def show_if_admin content = nil
    if is_admin?
      if block_given?
        yield
      else
        content
      end
    end
  end
  helper_method :show_if_admin
end
