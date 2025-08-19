class ChangeSubjectTypeInChats < ActiveRecord::Migration[7.1]
  def change
    change_column :chats, :subject, :text
  end
end
