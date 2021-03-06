class Message < ActiveRecord::Base
  attr_accessible :chat_message, :chat_body, :chat_author, :chat_user_id
  serialize :chat_message, Hash

  define_index do
    indexes chat_body
    indexes chat_author
  end
end
