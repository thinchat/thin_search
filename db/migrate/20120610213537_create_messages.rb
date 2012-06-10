class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :chat_body
      t.text :chat_message
      t.timestamps
    end
  end
end
