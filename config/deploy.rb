set :application, "gocool"
set :deploy_to, "/data/apps/#{application}"
 
set :scm, :git
set :repository, "git://github.com/gcao/gocool.git"
set :git_enable_submodules, true
set :deploy_via, :remote_cache 
 
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
