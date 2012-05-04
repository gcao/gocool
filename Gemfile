source 'https://rubygems.org'

# bundler requires these gems in all environments
gem "rails", "~>3.2.0"
gem 'jquery-rails'
gem "mysql2"
gem "json"
# gem "calendar_date_select"
gem "paperclip"
gem "haml", "~>3.1.0"
gem "will_paginate"
gem "hoptoad_notifier"
gem "aasm"
gem "nokogiri"
# gem "newrelic_rpm"
gem "formtastic"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "compass", "~>0.12.0"
  gem 'compass-rails', '~> 1.0.0'
  gem 'uglifier', '>= 1.0.3'
end

git "git://github.com/gcao/discuz_robot.git" do
# git File.expand_path(File.dirname(__FILE__) + "/../discuz_robot/.git") do
  gem "discuz_robot"
end

git "git://github.com/gcao/sgf_parser.git" do
# git File.expand_path(File.dirname(__FILE__) + "/../sgf_parser/.git") do
  gem "sgf_parser", :require => "sgf"
end

git "git://github.com/gcao/discuz_int.git", :branch => "rails3" do
# git File.expand_path(File.dirname(__FILE__) + "/../discuz_int/.git"), :branch => "rails3" do
  gem "discuz_int", :require => 'discuz_int'
end

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
  # gem 'rubaidh-google_analytics', :require => 'rubaidh/google_analytics'
  gem 'rack-bug', :require => "rack/bug"
  gem "guard"
  gem "guard-bundler"
  gem "guard-shell"
  gem "rb-fsevent"
  # brew install growl_notify
  gem "growl"
end

group :test do
  # bundler requires these gems while running tests
  gem "rspec", ">= 1.2.8"
  gem "rspec-rails", ">= 1.2.7.1"
  gem "mocha"
  gem "spork"
end

group :production do
  gem "SyslogLogger", :require => 'syslog_logger'
  # gem "rubaidh-google_analytics"
end

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
