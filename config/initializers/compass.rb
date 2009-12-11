require 'compass'
# If you have any compass plugins, require them here.
Compass.configuration.parse(File.join(RAILS_ROOT, "config", "compass.config"))
Compass.configuration.environment = RAILS_ENV.to_sym
Compass.configure_sass_plugin!

# Uncomment this on production server
#asset_host do |asset|
#  "http://assets%d.go-cool.org" % (asset.hash % 4)
#end
