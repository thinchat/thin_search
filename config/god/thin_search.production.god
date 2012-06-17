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

God.watch do |w|
  w.name = "resque worker"
  w.env      = {"QUEUE"=>"*"}
  w.start    = "bundle exec rake environment resque:work"
  w.log = '/var/log/god/search_worker.log'
end