class AddNicknameToSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :sessions, :nickname, :string
  end
end
