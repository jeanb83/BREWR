class Notification < ApplicationRecord
  belongs_to :user

  validates :content, presence: true

  after_validation :set_zero_by_default

  # Notification to group members that a new message has been sent
  def self.new_group_message(message)
    group = message.group
    group.users.each do |user|
      notification = Notification.new(user: user,
                                      from_model: "user",
                                      from_model_avatar_file: message.user.avatar_file,
                                      from_model_link: "/groups/#{group.id}")
      notification.content = "#{message.user.nickname} has sent a new message in your group #{group.title}. Go check it out!"
      if notification.valid?
        notification.save
      else
        puts "------ /!/ ERROR: Can't save NewGroupMessage notification. Not valid."
        p notification
      end
    end
  end

  # Notification to a new group member that has been invited
  def self.new_group_member(group_membership)
    user = group_membership.user
    group = group_membership.group
    notification = Notification.new(user: user,
                                    from_model: "group",
                                    from_model_avatar_file: group.avatar_file,
                                    from_model_link: "/groups/#{group.id}")
    notification.content = "You have been invited as a member of #{group.title}!"
    if notification.valid?
      notification.save
    else
      puts "------ /!/ ERROR: Can't save NewGroupMember notification. Not valid."
      p notification
    end
  end

  # Notification for all group members that a new event has been created
  def self.new_event(event)
    event.users.each do |user|
      notification = Notification.new(user: user,
                                      from_model: "event",
                                      from_model_avatar_file: event.avatar_file,
                                      from_model_link: "/events/#{event.id}")
      notification.content = "There is a new event for #{event.title} in your group #{event.group.title}. Go vote for it quick!"
      if notification.valid?
        notification.save
      else
        puts "------ /!/ ERROR: Can't save NewEvent notification. Not valid."
        p notification
      end
    end
  end

  # Notification to all event members that event has made it to stage 2
  def self.upstaged_to_2(event)
    random_user = User.find(event.random_user_id)
    event.users.each do |user|
      notification = Notification.new(user: user,
                                      from_model: "event",
                                      from_model_avatar_file: event.avatar_file,
                                      from_model_link: "/events/#{event.id}")
      notification.content = "Great, everyone has voted for #{event.title}! #{random_user.nickname} will now make the booking."
      if notification.valid?
        notification.save
      else
        puts "------ /!/ ERROR: Can't save UpStagedTo2 notification. Not valid."
        p notification
      end
    end
  end

  # Notification to all event members that event has made it to stage 3
  def self.upstaged_to_3(event)
    event_place = event.event_places.find_by(booking_status: true)
    event.users.each do |user|
      notification = Notification.new(user: user,
                                      from_model: "event",
                                      from_model_avatar_file: event.avatar_file,
                                      from_model_link: "/events/#{event.id}")
      notification.content = "All right! You are going out on #{event.date.strftime('%b %d')} at #{event_place.yelp_name} (#{event_place.city}) for #{event.title}!"
      if notification.valid?
        notification.save
      else
        puts "------ /!/ ERROR: Can't save UpStagedTo3 notification. Not valid."
        p notification
        errors += 1
      end
    end
  end

  private

  def set_zero_by_default
    @importance = 0 if @importance.nil?
  end
end
