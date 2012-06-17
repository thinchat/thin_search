require 'eventmachine'

task :listen => :environment do
  EM.run do
    REDIS.subscribe('thinchat') do |on|
      on.message do |channel, msg|
        puts msg.inspect
        Resque.enqueue(IndexJob, msg)
      end
    end
  end
end 
