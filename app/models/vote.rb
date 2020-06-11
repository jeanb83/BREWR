class Vote < ApplicationRecord
  VOTE_TYPES = ["Bistros", "Breakfast & Brunch", "Burgers", "Chinese",
                 "French", "Indian", "Italian", "Japanese", "Korean",
                 "Pizza", "Sushi", "Thai", "Vegan"]

  belongs_to :event_membership
  validates :value, inclusion: { in: VOTE_TYPES }
  validates :value, inclusion: { in: [nil, -100, 0, 1] }

  def self.get_vote_types
    return VOTE_TYPES
  end
end
