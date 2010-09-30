set :application, "gocool"
set :deploy_to, "/data/apps/#{application}"
 
set :scm, :git
set :repository, "git://github.com/gcao/gocool.git"
set :branch, "rails3"
set :git_enable_submodules, true
#set :deploy_via, :remote_cache

set :user, "root"
set :use_sudo, false

# ami_host = `ami_host`.strip
ami_host = "ec2-184-73-35-156.compute-1.amazonaws.com"

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

task :bundle, :role => [:app, :web] do
  deploy.create_bundler_symlink
  run "cd #{release_path} ; bundle check 2>&1 > /dev/null ; if [ $? -ne 0 ] ; then sh -c 'bundle install --deployment --without test' ; fi"
end

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
