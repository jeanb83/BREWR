class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :events, dependent: :destroy

  has_many :users, through: :group_memberships
end
