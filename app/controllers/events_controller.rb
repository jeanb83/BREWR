class EventsController < ApplicationController
  before_action :set_group, only: [:new, :create]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_event_id, only: [:full, :booked]
  # before_action :authenticate_user!

  def show
    # Set event users
    @users = @event.users
    # Set event group
    @group = @event.group
    # STAGE 1 (VOTE)
    if @event.stage == 1
      @event_membership = EventMembership.find_by(user_id: current_user, event_id: @event)
    # STAGE 2
    elsif @event.stage == 2
      # Set pending places
      set_pending_places
      # Current place is the first pending event places
      set_current_place(@event_places)
      # Set random user
      @random_user = User.find(@event.random_user_id)
    # STAGE 3
    elsif @event.stage == 3
      # Final event place is the one that is booked
      @event_place = EventPlace.find_by(booking_status: "booked")
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
      # If save success all group members will be invited (after_create method) to the event
      # Send notifications
      Notification.new_event(event)
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

  def full
    # Set pending places
    set_pending_places
    # Current place is the first pending event places
    set_current_place(@event_places)

    # Update booking status to full
    @event_place.booking_status = "full"

    # Save event place
    if @event_place.save
      # If save success redirect to event show
      redirect_to event_path(@event)
    else
      # If failure, log the event in the console
      p "- ERROR: Failed to update event:\n#{@event}."
      # And render the edit form again
      render "show"
    end
  end

  def booked
    # Set pending places
    set_pending_places
    # Current place is the first pending event places
    set_current_place(@event_places)

    # Update booking status to booked
    @event_place.booking_status = "booked"
    # Update stage to 3
    @event.stage = 3

    # Save event AND event_place
    if @event.save && @event_place.save
      # Send notifications
      Notification.upstaged_to_3(@event, @event_place)
      # If save success redirect to event show
      redirect_to event_path(@event)
    else
      # If failure, log the event in the console
      p "- ERROR: Failed to update event:\n#{@event}."
      # And render the edit form again
      render "show"
    end
  end

  private

  # Find event by id in DB
  def set_event
    @event = Event.find(params[:id])
  end

  # Find event by event_id in DB
  def set_event_id
    @event = Event.find(params[:event_id])
  end

  # Find group by group_id in DB
  def set_group
    @group = Group.find(params[:group_id])
  end

  # Whitelist params
  def event_params
    params.require(:event).permit(:title, :date, :city, :avatar_file)
  end

  # Set the pending places
  def set_pending_places
    @event_places = EventPlace.where(booking_status: "pending")
  end

  # Set current event place
  def set_current_place(event_places)
    @event_place = event_places[0]
  end
end
