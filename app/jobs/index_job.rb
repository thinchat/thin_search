require 'json'

class IndexJob
  @queue = :index

  def self.perform(msg)
    puts "HELLO YOU super SUCK"
    data = JSON.parse(msg)
    puts "STUFF COMING AT YOU"
    puts data['data']['chat_message'].inspect
    Message.create(chat_message: data['data']['chat_message'], chat_body: data['data']['chat_message']['message_body'])
  end
end

# index the query