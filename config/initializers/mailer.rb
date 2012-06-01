if Rails.env == 'production'
  require 'tlsmail'

  Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :address              => 'smtp.gmail.com',
    :port                 => 587,
    :tls                  => true,
    :domain               => 'gmail.com', #you can also use google.com
    :authentication       => :plain,
    :user_name            => ENV["GMAIL_USERNAME"],
    :password             => ENV["GMAIL_PASSWORD"]
  }
else
  ActionMailer::Base.delivery_method   = :sendmail
  ActionMailer::Base.sendmail_settings = {
     :location  => '/usr/sbin/sendmail',
     :arguments => '-i'
  }
end

