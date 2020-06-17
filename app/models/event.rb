class Event < ApplicationRecord
  belongs_to :group


  has_many :event_memberships, dependent: :destroy
  has_many :event_places, dependent: :destroy

  has_many :users, through: :event_memberships
  has_many :votes, through: :event_memberships

  validates :title, presence: true
  validates :date, presence: true
  validates :city, presence: true

  after_create :set_stage_to_zero

def get_deadline_timestamp
  deadline = self.created_at + 4.hours
  deadline.to_i * 1000
end

  private

  def set_stage_to_zero
    @stage = 0
  end
end
