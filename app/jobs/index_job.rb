class IndexJob
  @queue = :index

  def self.perform(msg)
    puts "HELLO YOU super SUCK"
    data = JSON.parse(msg)
    puts data['data']['chat_message']
    puts "STUFF COMING AT YOU"
    
    Message.create(chat_message: data['data']['chat_message'], chat_body: data['data']['chat_message']['message_body'],
                    chat_author: data['data']['chat_message']['user_name'], chat_user_id:  data['data']['chat_message']['user_id'])
  end
end

# index the query