raise "Environment variable CHEF_SERVER is not set." unless ENV["CHEF_SERVER"]
raise "Environment variable CHEF_USER is not set." unless ENV["CHEF_USER"]

set :application, "gocool"
set :deploy_to, "/data/apps/#{application}"

set :scm, :git
set :repository, "git://github.com/gcao/gocool.git"
set :branch, "rails3"
set :git_enable_submodules, true
set :git_submodules_recursive, false

set :user, ENV["CHEF_USER"]
set :use_sudo, ENV["CHEF_USER"] != 'root'
#set :runner, "root"  # Is this required when user is not root?

server ENV["CHEF_SERVER"], :app, :web, :db, :primary => true

namespace :deploy do
  task :start do
  end

  task :stop do
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    try_runner "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy:update_code" do
  copy_over_config_files
  run "mkdir #{release_path}/public/assets"
  run "chmod -R a+w #{release_path}/public/assets #{release_path}/public/javascripts/cache #{release_path}/public/stylesheets/cache #{release_path}/public/stylesheets/compiled"
end

task :copy_over_config_files do
  run "cp -rf #{deploy_to}/#{shared_dir}/config/* #{release_path}/config/"
end

require 'bundler/capistrano'
require 'hoptoad_notifier/capistrano' if ENV['DEPLOYMENT_TARGET'] == 'production'
