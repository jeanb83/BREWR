class VotesController < ApplicationController

  def bulk_create
    tastes = params[:tastes]
    event = Event.find(params[:event_id])
    event_membership = EventMembership.find_by(user: current_user, event: event)
    tastes.each do |taste, like|
      vote = Vote.new(taste: taste, like: like.to_i)
      vote.event_membership = event_membership
      vote.save
      redirect_to event_path(event)
    end
  end

  private

end
