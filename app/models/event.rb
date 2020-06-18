class Event < ApplicationRecord
  belongs_to :group


  has_many :event_memberships, dependent: :destroy
  has_many :event_places, dependent: :destroy

  has_many :users, through: :event_memberships
  has_many :votes, through: :event_memberships

  validates :title, presence: true
  validates :date, presence: true
  validates :city, presence: true

  after_create :invite_group_members

  def get_deadline_timestamp
    deadline = self.created_at + 48.hours
    deadline.to_i * 1000
  end

  private

  def invite_group_members
    # Get the users list
    users = self.group.users
    users.each do |user|
      # For each user in the list create an Event Membership with status true by default
      event_membership = EventMembership.create(user: user, event: self, status: true)
    end
  end
end
