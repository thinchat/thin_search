class AddChatUserIdAndChatAuthorToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :chat_user_id, :integer
    add_column :messages, :chat_author, :string
  end
end
