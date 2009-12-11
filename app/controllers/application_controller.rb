# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication, EmailParamHandler
  include ExceptionNotifiable if RAILS_ENV=='production'

  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  if ENV['INTEGRATE_WITH_FORUM'] == 'true'
    layout 'application_integrated'
  end
  
  before_filter :set_title_and_header
  before_filter :set_locale
  
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

  def page_params
    page_size = (params[:page_size] || ENV['ROWS_PER_PAGE']).to_i
    { :per_page => page_size, :page => params[:page] }
  end
end
