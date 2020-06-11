class Vote < ApplicationRecord
  VOTE_TASTES = ["Bistros", "Breakfast & Brunch", "Burgers", "Chinese",
                 "French", "Indian", "Italian", "Japanese", "Korean",
                 "Pizza", "Sushi", "Thai", "Vegan"]

  belongs_to :event_membership
  validates :taste, inclusion: { in: VOTE_TASTES }
  validates :like, inclusion: { in: [nil, -100, 0, 1] }

  def self.get_vote_tastes
    return VOTE_TASTES
  end
end
