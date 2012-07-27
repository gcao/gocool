# Look here for cleanup/refactoring ideas: http://github.com/leehambley/railsless-deploy/
load 'deploy' if respond_to?(:namespace) # cap2 differentiator

raise "Environment variable CHEF_SERVER is not set." unless ENV["CHEF_SERVER"]
raise "Environment variable CHEF_USER is not set." unless ENV["CHEF_USER"]

set :application, "jsgameviewer"
set :deploy_to, "/data/apps/#{application}"

set :scm, :git
set :repository, "git://github.com/gcao/jsgameviewer.git"

set :normalize_asset_timestamps, false

set :user, ENV["CHEF_USER"]
set :use_sudo, ENV["CHEF_USER"] != 'root'

server ENV["CHEF_SERVER"], :app, :web, :db, :primary => true

