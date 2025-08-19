class Chat < ApplicationRecord
  belongs_to :users, :politenesses
  has_many :messages

  validates :politeness_id, :receiver, :subject, presence: true
end
