set :application, "gocool"
set :deploy_to, "/data/apps/#{application}"
 
set :scm, :git
set :repository, "git://github.com/gcao/gocool.git"
set :git_enable_submodules, true
#set :deploy_via, :remote_cache
 
set :user, "root"
set :use_sudo, false

ami_host = `ami_host`.strip

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
  # run "for config_file in #{deploy_to}/#{shared_dir}/config/*.*; do ln -nfs $config_file #{release_path}/config/`basename $config_file`; done"
  # run "for config_file in #{deploy_to}/#{shared_dir}/config/initializers/*.*; do ln -nfs $config_file #{release_path}/config/initializers/`basename $config_file`; done"
end
