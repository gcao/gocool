require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']
source 'https://rubygems.org'
gem 'rails', '3.2.3'
gem 'mysql2', "~> 0.3.0"
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem "haml", ">= 3.1.5"
gem "haml-rails", ">= 0.3.4", :group => :development
gem "rspec-rails", ">= 2.10.1", :group => [:development, :test]
gem "machinist", :group => :test
gem "factory_girl_rails", ">= 3.2.0", :group => [:development, :test]
gem "email_spec", ">= 1.2.1", :group => :test
gem "guard", ">= 0.6.2", :group => :development  
case HOST_OS
  when /darwin/i
    gem 'rb-fsevent', :group => :development
    gem 'growl', :group => :development
  when /linux/i
    gem 'libnotify', :group => :development
    gem 'rb-inotify', :group => :development
  when /mswin|windows/i
    gem 'rb-fchange', :group => :development
    gem 'win32console', :group => :development
    gem 'rb-notifu', :group => :development
end
gem "guard-bundler", ">= 0.1.3", :group => :development
gem "guard-rails", ">= 0.0.3", :group => :development
gem "guard-livereload", ">= 0.3.0", :group => :development
gem "guard-rspec", ">= 0.4.3", :group => :development
gem "rack-livereload", ">= 0.3.6", :group => :development
gem "devise", ">= 2.1.0.rc2"
gem "cancan", ">= 1.6.7"
gem "rolify", ">= 3.1.0"
gem "bootstrap-sass", ">= 2.0.1"
gem "simple_form", "~> 2.0.0"
gem "aasm", "~> 3.0.0"
gem "will_paginate", ">= 3.0.3"
gem "paperclip", "~> 3.0.0"
gem "tlsmail", :group => :production
gem "sgf_parser", :require => "sgf", :path => "vendor/gems/sgf_parser"
gem "cool_games", :path => "vendor/gems/cool_games"
gem "thin", :group => :development

