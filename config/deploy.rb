raise "Environment variable CHEF_SERVER is not set." unless ENV["CHEF_SERVER"]
raise "Environment variable CHEF_USER is not set." unless ENV["CHEF_USER"]

set :application, "gocool"
set :deploy_to, "/data/apps/#{application}"

set :scm, :git
set :repository, "git://github.com/gcao/gocool.git"
set :git_enable_submodules, true
#set :deploy_via, :remote_cache

set :user, ENV["CHEF_USER"]
set :use_sudo, ENV["CHEF_USER"] != 'root'

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

after "deploy:update_code", :copy_over_config_files

task :copy_over_config_files do
  run "cp -rf #{deploy_to}/#{shared_dir}/config/* #{release_path}/config/"
  run "chmod -R a+w #{release_path}/public/stylesheets/cache #{release_path}/public/javascripts/cache"
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
