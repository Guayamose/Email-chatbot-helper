class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.string :title
      t.string :politeness_level
      t.string :receiver
      t.string :subject
      t.references :users, null: false, foreign_key: true

      t.timestamps
    end
  end
end
