class AddPolitenessLevelIdToChats < ActiveRecord::Migration[7.1]
  def change
    add_reference :chats, :politeness, foreign_key: { to_table: :politenesses }
  end
end
