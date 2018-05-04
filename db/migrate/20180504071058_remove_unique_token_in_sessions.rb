class RemoveUniqueTokenInSessions < ActiveRecord::Migration[5.1]
  def change
    remove_index :sessions, :token
  end
end
