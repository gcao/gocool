# See here: http://gembundler.com/v1.0/rails23.html

source "http://rubygems.org"
# source "http://gems.github.com"

# bundler requires these gems in all environments
gem "rails", ">=3.0.0"
gem "aspect4r"
gem "mysql"
gem "json"
# gem "calendar_date_select"
gem "paperclip"
gem "haml"
gem "compass"
gem "will_paginate"
gem "hoptoad_notifier"
gem "aasm"
gem "nokogiri"
# gem "newrelic_rpm"
gem "jammit"
gem "formtastic"

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
