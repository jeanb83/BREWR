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

  def check_stage_2_conditions?
    if @votes.count >= @event_memberships.where.not(status: false).count
      @stage = 2
      save
      return true
    end
  end

  def check_stage_3_conditions?
    unless EventPlaces.where(event_id: @event).where(booking_status: true).empty?
      @stage = 3
      save
      return true
    end
  end

  private

  def set_stage_to_zero
    @stage = 0
  end
end
