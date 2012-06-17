God.watch do |w|
  w.name "search listener"
  w.start "cd /home/apps/thin_search/current; rake listen"
  w.log '/var/log/god/search_listener.log'
  w.keepalive
end