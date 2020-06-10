class EventMembership < ApplicationRecord
  belongs_to :user
  belongs_to :event

  has_many :votes, dependent: :destroy
end
