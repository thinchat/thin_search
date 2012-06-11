require File.expand_path('../config/application', __FILE__)

ThinSearch::Application.load_tasks

# Resque tasks
require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'

    ENV['RAILS_ENV'] = Rails.env
    
    Resque.schedule = YAML.load_file('config/resque_schedule.yml')


  end
end