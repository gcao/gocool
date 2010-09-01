# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::VendorGemSourceIndex.silence_spec_warnings = true

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  config.load_paths += %W(#{RAILS_ROOT}/app/misc)

  config.action_controller.relative_url_root = "/app"
  
  config.action_controller.session = {
    :key         => '_gocool_session',
    :secret      => '3ab0ef9713356fa8d08424c770584d95ad14f2ae54d43c9b8e4881b5491fe024407ec2f45548384946410d5a412c0c1dea5ab21da811fb43e2c538fa817d1cdc'
  }
end

Time.zone = "Beijing"
require 'open-uri'
