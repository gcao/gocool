set :application, "gocool"
set :deploy_to, "/data/apps/#{application}"
 
set :scm, :git
set :repository, "git@github.com:gcao/gocool.git"
 
set :user, "gcao"
set :use_sudo, false

# AMI ami-0d729464: ubuntu 9.04 server base 
server %x(ami_host).strip, :app, :web, :db, :primary => true
