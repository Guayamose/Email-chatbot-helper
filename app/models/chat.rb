class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :politeness

  has_many :messages, dependent: :destroy

  validates :title, :politeness_id, :receiver, presence: true
end
