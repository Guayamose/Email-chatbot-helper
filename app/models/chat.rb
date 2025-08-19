class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :politeness

  has_many :messages, dependent: :destroy

  validates :politeness_id, :receiver, :subject, presence: true
end
