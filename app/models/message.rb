class Message < ApplicationRecord
  belongs_to :chat
  has_many_attached :documents

  validates :content, presence: true

end
