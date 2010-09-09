I18n.load_path = Dir.glob("#{Rails.root}/config/locales/**/*.{rb,yml}")
I18n.default_locale = ENV['DEFAULT_LOCALE']
I18n.reload!
