# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
#config.action_controller.asset_host = "http://assets%d.go-cool.org"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

config.gem 'rubaidh-google_analytics', :lib => 'rubaidh/google_analytics', :source => 'http://gems.github.com'

require 'syslog_logger'
RAILS_DEFAULT_LOGGER = SyslogLogger.new

config.action_mailer.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.sendmail_settings = {
  :location  => '/usr/sbin/sendmail',
  :arguments => '-i -t'
}
