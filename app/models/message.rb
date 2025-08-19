class Message < ApplicationRecord
  belongs_to :chats

  validates :content, presence: true
end
