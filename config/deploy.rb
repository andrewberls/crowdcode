require "bundler/capistrano"
require 'bundler/capistrano'

set :application, "crowdcode"
set :repository,  "https://github.com/andrewberls/crowdcode.git"
set :scm, :git
set :branch, "master"
set :normalize_asset_timestamps, false

set :user, "ubuntu"
set :use_sudo, false
set :deploy_to, "/var/www/crowdcode"

role :web, "54.215.187.53"                         # Your HTTP server, Apache/etc
role :app, "54.215.187.53"                         # This may be the same as your `Web` server
role :db, "54.215.187.53", :primary => true        # This is where Rals migrations will run
#role :db,  "your slave db-server here"

set :keep_releases, 5
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
#namespace :deploy do
#  task :start do ; end
#  task :stop do ; end
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#  end
#end
ssh_options[:forward_agent] = true

after 'deploy:update_code', :bundle_install

desc 'install the necessary prerequisites'
task :bundle_install, roles: :app do
  run "cd #{release_path} && bundle install"
  run "cd #{release_path} && rake assets:precompile"
end
