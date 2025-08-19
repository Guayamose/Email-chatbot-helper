class RemovePolitenessLevelFromChats < ActiveRecord::Migration[7.1]
  def change
    remove_column :chats, :politeness_level, :string
  end
end
