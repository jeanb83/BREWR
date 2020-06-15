class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :group_memberships, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :event_memberships, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :events, through: :event_memberships
  has_many :groups, through: :group_memberships

  validates :nickname, presence: true, uniqueness: true

  def has_voted?(event)
    membership = EventMembership.find_by(user_id: self, event_id: event)
    user_votes = membership.votes.empty?
    if user_votes.nil?
      return false
    else
      return true
    end
  end
end
