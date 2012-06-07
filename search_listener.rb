require 'eventmachine'
require 'redis'
require 'json'
require 'resque'
load 'app/jobs/index_job.rb'

EM.run do
  redis = Redis.new(:host => 'localhost', :port => 6379)

  redis.subscribe('thinchat') do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      puts data.inspect
      Resque.enqueue(IndexJob, msg)
    end
  end
end

# { 'chat_message' => { 'poster_name' => 'Ed', 
#                       'poster_id' => '5', 
#                       'poster_type' => 'guest', 
#                       'message_id' => '801'
#                       'message_type' => 'message', 
#                       'message_body' => 'Hello, world!',
#                       'metadata' => { },
#                       'created_at' => '12:00:12' } }