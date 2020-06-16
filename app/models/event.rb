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

  private

  def set_stage_to_zero
    @stage = 0
  end
end
