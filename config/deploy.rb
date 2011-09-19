set :application, "gocool3"
set :deploy_to, "/data/apps/#{application}"
 
set :scm, :git
set :repository, "git://github.com/gcao/gocool.git"
set :branch, "rails3"
set :git_enable_submodules, true
set :git_submodules_recursive, false

set :user, "root"
set :use_sudo, false

ami_host = `ami_host`.strip
# ami_host = `new_instance`.strip

# AMI ami-0d729464: ubuntu 9.04 server base 
server ami_host, :app, :web, :db, :primary => true

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

require 'bundler/capistrano'
require 'hoptoad_notifier/capistrano'
