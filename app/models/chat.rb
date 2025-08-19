class Chat < ApplicationRecord
  belongs_to :users
  has_many :messages

  validates :politeness_level, :receiver, :subject, presence: true
end
