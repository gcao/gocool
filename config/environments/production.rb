Gocool::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.action_controller.perform_caching             = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  config.logger = SyslogLogger.new 'gocool'

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and javascripts from an asset server
  #config.action_controller.asset_host = "http://assets%d.go-cool.org"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # require 'syslog_logger'
  # RAILS_DEFAULT_LOGGER = SyslogLogger.new

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # Precompile *all* assets, except those that start with underscore
  config.assets.precompile << /(^[^_\/]|\/[^_])[^\/]*$/

  config.action_mailer.raise_delivery_errors = true
  ActionMailer::Base.delivery_method = :sendmail
  ActionMailer::Base.sendmail_settings = {
    :location  => '/usr/sbin/sendmail',
    :arguments => '-i -t'
  }
end
