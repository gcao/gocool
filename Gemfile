# See here: http://gembundler.com/v1.0/rails23.html

source "http://rubygems.org"
source "http://gems.github.com"

# bundler requires these gems in all environments
gem "rails", "2.3.8"
gem "mysql"
gem "json"
gem "calendar_date_select", ">=1.15"
gem "thoughtbot-paperclip", ">=2.3.0", :require => "paperclip"
gem "haml", ">=2.2.3"
gem "chriseppstein-compass", ">=0.8.11", :require => "compass"
gem "mislav-will_paginate", ">=2.3.11", :require => "will_paginate"
gem "binarylogic-searchlogic", :require => "searchlogic"
gem "hoptoad_notifier"
gem "rubyist-aasm", :require => "aasm"
gem "calendar_date_select", ">=1.15"
gem "nokogiri"
gem "newrelic_rpm"
gem "jammit"
gem "capistrano"
gem "discuz_robot", "~>0.1.0"
gem "sgf_parser", "~>0.1.0"

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
  # gem 'rubaidh-google_analytics', :require => 'rubaidh/google_analytics'
  gem 'ruby-growl' 
  # gem 'bullet', ">=2.0.0.beta.2"
  gem 'rack-bug', :require => "rack/bug"
  gem "mongrel"
end

group :test do
  # bundler requires these gems while running tests
  gem "rspec", ">= 1.2.8"
  gem "rspec-rails", ">= 1.2.7.1"
  gem "mocha"
  gem "spork"
end

group :production do
  gem "syslog-logger"
  gem "rubaidh-google_analytics"
end
