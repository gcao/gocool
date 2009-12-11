I18n.load_path = Dir.glob("#{RAILS_ROOT}/config/locales/**/*.{rb,yml}")
I18n.default_locale = ENV['DEFAULT_LOCALE']
I18n.reload!
