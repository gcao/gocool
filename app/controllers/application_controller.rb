# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication, EmailParamHandler
  
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  before_filter :set_title
  before_filter :set_locale
  
  def set_title
    @title = t('shared.title')
  end
  
  def set_locale
    I18n.locale = @locale = params[:locale] || cookies[:locale] || "en_us"
    cookies[:locale] = {:value => @locale, :expires => 100.year.from.now }
  end
  
  def send_file file
    if ENV["USE_XSENDFILE"] == "true"
      response.headers['X-Sendfile'] = file
      render :nothing => true
    else
      render :file => file
    end
  end
end
