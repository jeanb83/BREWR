class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_group, only: [:new, :create]
  # before_action :authenticate_user!

  def show
    # Set event users
    @users = @event.users
    # Set event group
    @group = @event.group
    # STAGE 1 (VOTE)
    if @event.stage == 1
      @event_membership = EventMembership.find_by(user_id: current_user, event_id: @event)
    # STAGE 2 (BOOKING)
    elsif @event.stage == 2
      set_last_stages_variables
    # STAGE 3 (BOOKED)
    elsif @event.stage == 3
      set_last_stages_variables
    end
  end

  def new
    @event = Event.new
  end

  def create
    # New event with name, date, city and avatar_file
    @event = Event.new(event_params)
    # Assign the group to the new event
    @event.group = @group
    # Set the stage of the group to 1 (VOTES)
    @event.stage = 1
    # Try to save
    if @event.save
      # If save success invite all the group members to the event
      invite_all_group_members_to_event(@group, @event)
      # And redirect to the event show
      redirect_to event_path(@event)
    else
      # If failure, log the event in the console
      p "- ERROR: Failed to create event:\n#{@event}."
      # And render the new form again
      render "new"
    end
  end

  def edit
    @group = @event.group
  end

  def update
    # Try to save
    if @event.update(event_params)
      # If save success redirect to event show
      redirect_to event_path(@event)
    else
      # If failure, log the event in the console
      p "- ERROR: Failed to update event:\n#{@event}."
      # And render the edit form again
      render "edit"
    end
  end

  def destroy
    # Store the group for further redirection
    @group = @event.group
    # Destroy the event
    @event.destroy
    # Redirect to the stored group show
    redirect_to group_path(@group)
  end

  private

  def set_event
    # Find event by id in DB
    @event = Event.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_last_stages_variables
    @event_places = EventPlace.where(event_id: @event).where.not(booking_status: false)
    @current_place = @event_places[0]
  end

  def event_params
    # Whitelist params
    params.require(:event).permit(:title, :date, :city, :avatar_file)
  end

  # Method for auto-inviting all group members to an event
  def invite_all_group_members_to_event(group, event)
    # Get the users list
    @users = group.users
    @users.each do |user|
      # For each user in the list create an Event Membership with status true by default
      event_membership = EventMembership.create(user: user, event: event, status: true)
    end
  end
end
