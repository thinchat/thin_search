class Message < ActiveRecord::Base
  attr_accessible :chat_message, :chat_body

  define_index do
    indexes chat_body
  end
end
