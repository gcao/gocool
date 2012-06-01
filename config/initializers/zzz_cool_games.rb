# This file is prefixed with zzz so that it's loaded after other initializers. Is this important?
Rails.application.config.paths['db/migrate'] += CoolGames::Engine.paths['db/migrate'].existent
