class Vote < ApplicationRecord
  belongs_to :event_membership
  TYPES = ["Bistros", "Breakfast & Brunch", "Burgers", "Chinese", "French", "Indian", "Italian", "Japanese", "Korean", "Pizza", "Sushi", "Thai", "Vegan"]

  def self.get_vote_types
    TYPES
  end
end


