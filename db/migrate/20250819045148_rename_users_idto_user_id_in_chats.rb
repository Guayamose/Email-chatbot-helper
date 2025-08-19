class RenameUsersIdtoUserIdInChats < ActiveRecord::Migration[7.1]
  def change
    rename_column :chats, :users_id, :user_id
  end
end
