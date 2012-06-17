God.watch do |w|
  w.name "search listener"
  w.start "cd #{deploy_to}/current; rake listen"
  w.log '/var/log/god/search_listener.log'
  w.keepalive
end