require 'eventmachine'
require 'redis'
require 'json'
require 'resque'
load 'app/jobs/index_job.rb'

EM.run do
  redis = Redis.new(:host => 'localhost', :port => 6379)
  Resque.redis = 'localhost:6379:1'

  redis.subscribe('thinchat') do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      Resque.enqueue(IndexJob, msg)
    end
  end
end

# "data"=>{"user_name"=>"Edward Weng",
#          "object"=>{ "body"=>"booyah!",
#                      "created_at"=>"2012-06-07T02:14:56Z", 
#                      "id"=>17, 
#                      "room_id"=>1, 
#                      "updated_at"=>"2012-06-07T02:14:56Z", 
#                      "user_id"=>2, 
#                      "user_name"=>"Edward Weng", 
#                      "user_type"=>"Agent" },
#          "type" => "Message" }

# { 'chat_message' => { x'user_name' => 'Ed', 
#                       x'user_id' => '5', 
#                       x'user_type' => 'guest', 
#                       x'message_id' => '801'
#                       'message_type' => 'message', 
#                       x'message_body' => 'Hello, world!',
#                       'metadata' => { },
#                       x'created_at' => '12:00:12'
#                       x'updated_at' => '12:00:12' } }