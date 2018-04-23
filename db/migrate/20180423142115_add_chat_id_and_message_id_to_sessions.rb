class AddChatIdAndMessageIdToSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :sessions, :chat_id, :integer
    add_column :sessions, :message_id, :integer
  end
end
