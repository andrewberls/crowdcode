require "bundler/capistrano"

set :application, "set your application name here"
set :repository,  "https://github.com/andrewberls/crowdcode.git"
set :scm, :git
set :branch, "master"
set :normalize_asset_timestamps, false

set :user, "ubuntu"
set :use_sudo, false
set :deploy_to, "/home/ubuntu/www/crowdcode"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "54.215.187.53"                         # Your HTTP server, Apache/etc
role :app, "54.215.187.53"                         # This may be the same as your `Web` server
role :db, "54.215.187.53", :primary => true                         # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

ssh_options[:keys] = ["/home/ubuntu/.ssh/first_pair.pem"]
ssh_options[:forward_agent] = true
