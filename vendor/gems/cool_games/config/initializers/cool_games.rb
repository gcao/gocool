Rails.application.config.autoload_paths += CoolGames::Engine.paths['app/controllers']
Rails.application.config.autoload_paths += CoolGames::Engine.paths['app/helpers']
Rails.application.config.autoload_paths += CoolGames::Engine.paths['app/models']

# See http://stackoverflow.com/questions/4526122/migrations-in-rails-engine
# And http://stackoverflow.com/a/8364459
Rails.application.config.paths['db/migrate'] = Rails.application.config.paths['db/migrate'] + CoolGames::Engine.paths['db/migrate']

ENV['ENCA_EXECUTABLE'] ||= '/usr/local/bin/enca'

