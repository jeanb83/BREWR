class Vote < ApplicationRecord
  VOTE_TASTES = ["Bistros", "Brunch", "Burgers", "Chinese",
                 "French", "Indian", "Italian", "Japanese", "Korean",
                 "Pizza", "Sushi", "Thai", "Vegan"]

  belongs_to :event_membership

  has_one :event, through: :event_membership

  validates :taste, inclusion: { in: VOTE_TASTES }
  validates :like, inclusion: { in: [nil, -100, 0, 1] }

  after_create :compile_votes

  def self.get_vote_tastes
    return VOTE_TASTES
  end

  private

  def compile_votes
    # Get the vote's event
    event = self.event
    # Check if there's enough votes
    if event.votes.group_by(&:event_membership_id).count >= event.event_memberships.count && event.votes.last.taste == VOTE_TASTES[-1]
      # Initialize compilation as a hash
      compiled_votes = {}
      # Initialize all possible tastes to 0 for compilation
      VOTE_TASTES.each do |taste|
        compiled_votes[taste] = 0
      end
      # Compile the votes
      event.votes.each do |vote|
        compiled_votes[vote.taste] += vote.like
      end
      # Get the bigger vote and store in events term column
      event.term = compiled_votes.max_by { |taste, like| like }[0]
      # Pass event to stage 2
      event.stage = 2
      # Random user set
      event.random_user_id = event.users.sample.id
      # Save
      event.save
      # Get results from Yelp
      Yelp.fetch_places(event)
      # Send notification to all event members
      Notification.upstaged_to_2(event)
    end
  end
  
end
