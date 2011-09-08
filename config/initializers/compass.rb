require 'compass'
# If you have any compass plugins, require them here.
Compass.add_project_configuration("#{Rails.root}/config/compass.config")
Compass.configuration.environment = Rails.env
Compass.configure_sass_plugin!
