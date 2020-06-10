class Notification < ApplicationRecord
  belongs_to :user

  validates :content, presence: true

  after_validation :set_zero_by_default

  private

  def set_zero_by_default
    @importance = 0 if @importance.nil?
  end
end
