class RenameChatsIdToChatIdInMessages < ActiveRecord::Migration[7.1]
  def change
    rename_column :messages, :chats_id, :chat_id
  end
end
