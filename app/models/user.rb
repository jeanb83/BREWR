class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :group_memberships, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :event_memberships, dependent: :destroy
  has_many :events, through: :event_memberships
  has_many :groups, through: :group_memberships

  validates :first_name, presence: true
  validates :last_name, presence: true
end
