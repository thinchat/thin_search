require 'redis'
require 'json'

redis = Redis.new(:host => 'localhost', :port => 6379)

data = {"user" => "Fat Joe"}

4.times do
  redis.publish 'thinchat', data.merge('msg' => "Lean back.").to_json
end