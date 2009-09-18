# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def process_email email_param
    session[:email] = init_email(email_param)
  end
  
  # return nil if valid, error message otherwise
  def validate_email email
    if email.blank?
      t('email.required')
    elsif not Gocool::Email.valid?(email)
      t('email.invalid')
    end
  end
  
  private
  
  def init_email email_param
    email = email_param || session[:email]
    normalize_email(email)
  end
  
  def normalize_email email
    return if email.blank?
    email.strip.downcase
  end
  
end
