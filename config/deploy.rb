require 'bundler/capistrano'

set :application, 'crowdcode'
set :repository,  'git://github.com/andrewberls/crowdcode.git'
set :domain, 'ec2-54-226-157-108.compute-1.amazonaws.com'
set :scm, :git
set :branch , fetch(:branch, 'master')

set :deploy_to, '/var/www/crowdcode'
set :user, 'ec2-user'
set :use_sudo, false

# Re-use a single git remote instead of cloning every time
set :deploy_via, :remote_cache

role :web, "ec2-54-226-157-108.compute-1.amazonaws.com"                # Your HTTP server, Apache/etc
role :app, "ec2-54-226-157-108.compute-1.amazonaws.com"                # This may be the same as your `Web` server
role :db,  "ec2-54-226-157-108.compute-1.amazonaws.com", primary: true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# Clean up old releases on each deploy
set :keep_releases, 5
after "deploy:restart", "deploy:cleanup"

after 'deploy:update_code', 'deploy:migrate'

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

ssh_options[:forward_agent] = true



after 'deploy:update_code', :bundle_install

desc 'install the necessary prerequisites'
task :bundle_install, roles: :app do
  run "cd #{release_path} && bundle install"
  run "cd #{release_path} && rake assets:precompile"
end
