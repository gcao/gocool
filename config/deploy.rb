set :application, "gocool"
set :deploy_to, "/data/apps/#{application}"
 
set :scm, :git
set :repository, "git://github.com/gcao/gocool.git"
set :git_enable_submodules, true
 
set :user, "root"
set :use_sudo, false

# AMI ami-0d729464: ubuntu 9.04 server base 
server "ec2-67-202-52-61.compute-1.amazonaws.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :start do
  end
  
  task :stop do
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    try_runner "touch #{current_path}/tmp/restart.txt"
  end
end
