class RemoveMessageIdFromSessions < ActiveRecord::Migration[5.1]
  def change
    remove_column :sessions, :message_id, :integer
  end
end
