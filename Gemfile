# See here: http://gembundler.com/v1.0/rails23.html

source "http://rubygems.org"
# source "http://gems.github.com"

# bundler requires these gems in all environments
gem "rails", ">=3.0.0"
gem "mysql"
gem "json"
# gem "calendar_date_select"
gem "paperclip"
gem "haml", ">=2.2.3"
gem "compass"
gem "will_paginate"
# gem "searchlogic"
gem "meta_search"
gem "hoptoad_notifier"
gem "aasm"
gem "nokogiri"
# gem "newrelic_rpm"
gem "jammit"

git "git://github.com/gcao/discuz_robot.git" do
# git "../discuz_robot/.git" do
  gem "discuz_robot"
end

git "git://github.com/gcao/sgf_parser.git" do
# git "../sgf_parser/.git" do
  gem "sgf_parser", :require => "sgf"
end

git "git://github.com/gcao/discuz_int.git", :branch => "rails3" do
# git "../discuz_int/.git", :branch => "rails3" do
  gem "discuz_int"
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
