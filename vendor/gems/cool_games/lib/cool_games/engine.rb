module CoolGames
  class Engine < ::Rails::Engine
    isolate_namespace CoolGames

    # This makes it possible to refer routes like cool_games.games_path
    engine_name 'cool_games'

    initializer "cool_games.set_auto_paths" do |app|
      app.config.autoload_paths += %W[#{CoolGames::Engine.root}/lib]
    end

    # Precompile assets that are not referenced from main app
    initializer "cool_games.assets.precompile" do |app|
      app.config.assets.precompile += %w[]
    end
  end
end
