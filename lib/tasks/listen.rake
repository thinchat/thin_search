require 'eventmachine'

desc "Listen for redis messages"
task :listen => :environment do
  EM.run do
    REDIS.subscribe('thinchat') do |on|
      on.message do |channel, msg|
        msg_json = JSON.parse(msg)
        if msg_json['data']['chat_message']['message_type'] == "Message"
          puts msg.inspect
          Resque.enqueue(IndexJob, msg)
        end
      end
    end
  end
end 
