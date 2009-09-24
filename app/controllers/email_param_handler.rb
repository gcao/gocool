module EmailParamHandler
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