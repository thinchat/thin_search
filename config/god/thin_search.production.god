God.watch do |w|
  w.name = "search listener"
  w.start = "cd /home/deployer/apps/thin_search/current; rake listen"
  w.log = '/var/log/god/search_listener.log'
  w.keepalive
end

God.watch do |w|
  w.name = "resque scheduler"
  w.start = "cd /home/deployer/apps/thin_search/current; bundle exec rake resque:scheduler"
  w.log = '/var/log/god/search_scheduler.log'
  w.keepalive
end

rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/home/deployer/apps/thin_search/current"

God.watch do |w|
  w.dir      = "#{rails_root}"
  w.name     = "resque-worker"
  w.group    = 'resque'
  w.interval = 30.seconds
  w.env      = {"QUEUE"=>"critical,high,low", "RAILS_ENV"=>rails_env}
  w.start    = "/usr/bin/rake -f #{rails_root}/Rakefile environment resque:work"
end