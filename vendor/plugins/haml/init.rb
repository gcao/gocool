require 'haml'

# Load Haml and Sass.
# Haml may be undefined if we're running gems:install.
Haml.init_rails(binding) if defined?(Haml)
