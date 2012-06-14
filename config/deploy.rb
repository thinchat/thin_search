require "bundler/capistrano"
require 'capistrano/ext/multistage'
require 'thinking_sphinx/deploy/capistrano'

set :stages, %w(production development staging) 
set :default_stage, "development"

set :application, "thin_search"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:thinchat/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:nginx_config", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
      run 
    end
  end

  task :secret, roles: :app do
    transfer(:up, "config/secret/database.yml", "#{shared_path}/config/database.yml", :scp => true)
    transfer(:up, "config/secret/redis_password.rb", "#{shared_path}/config/secret/redis_password.rb", :scp => true)
  end
  before "deploy:symlink_config", "deploy:secret"

  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/config/secret"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "mkdir -p #{release_path}/config/secret"
    run "ln -nfs #{shared_path}/config/secret/redis_password.rb #{release_path}/config/secret/redis_password.rb"
    sudo "ln -nfs #{current_path}/config/unicorn/unicorn_#{stage}_init.sh /etc/init.d/unicorn_#{application}"
    run "chmod +x #{release_path}/config/unicorn/unicorn_#{stage}_init.sh"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"

  before 'deploy:update_code', 'thinking_sphinx:stop'
  after 'deploy:update_code', 'thinking_sphinx:start'

  namespace :thinking_sphinx do
    desc "Symlink Sphinx indexes"
    task :symlink_indexes, :roles => [:app] do
      run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
    end
  end

after 'deploy:finalize_update', 'thinking_sphinx:symlink_indexes'
end
