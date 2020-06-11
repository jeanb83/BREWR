# REQUIRES

# SEED VARIABLES
# Users variables
users_number = 25
# Groups variables
groups_number = 7
# Group Memberships variables
users_per_group = [2, 8]
# Messages variables
messages_per_group = [3, 18]
# Events variables
events_per_group = [1, 3]
events_max_days_forward = 20
# Votes variables
stage_2_events_number = 3 # Inferior to minimum events_number * groups_number !
stage_3_events_number = 1 # Inferior to stage_2_events_number !
vote_types = Vote.get_vote_types
vote_values = [-100, 0, 1]
# General seed variables
last_users_number = 3 # Number of user emails to display at the end to access the website
errors = 0 # Starting errors counter

# OPTIONS
# Users
clean_users = true
if User.all.count >= users_number
  seed_users = true # Don't touch
else
  seed_users = false # Don't touch
end
# Groups (requires users in db!)
clean_groups = true
seed_groups = true
# Group Memberships (requires groups & users in db!)
if clean_groups || clean_users
  clean_group_memberships = true # Don't touch
else
  clean_group_memberships = false # Don't touch
end
seed_group_memberships = true
# Messages (requires groups & users in db!)
clean_messages = true
seed_messages = true
# Events (requires groups & users in db!)
clean_events = true
seed_events = true
# Event Memberships (requires groups & users in db!)
if clean_groups || clean_users || clean_events
  clean_event_memberships = true # Don't touch
else
  clean_event_memberships = false # Don't touch
end
seed_event_memberships = true
# Votes (requires groups & users & events in db!)
if clean_event_memberships
  clean_votes = true # Don't touch
else
  clean_votes = false # Don't touch
end
seed_votes = true
# Notifications (requires users in db!)
clean_notifications = true
seed_notifications = true
# Database
if clean_users || clean_groups || clean_messages || clean_events || clean_votes || clean_notifications
  clean_database = true # Don't touch
else
  clean_database = false # Don't touch
end
# Event Places
clean_event_places = true
seed_event_places = true



# FRONT END
def main_separator
  puts "\n\n" + "*" * 50 + "\n\n"
end

def alt_separator
  puts "\n" + "-" * 50 + "\n\n"
end


# ---------------------------------------------


# START SEED
puts "SEED STARTED..."

main_separator


# ---------------------------------------------


# CLEAN DB
if clean_database
  puts "CLEANING DATABASE..."

  if clean_notifications
    puts "-- Cleaning Notifications..."
    Notification.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_event_places
    puts "-- Cleaning Event Places..."
    EventPlace.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_votes
    puts "-- Cleaning Votes..."
    Vote.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_event_memberships
    puts "-- Cleaning Event Memberships..."
    EventMembershp.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_events
    puts "-- Cleaning Events..."
    Event.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_messages
    puts "-- Cleaning Messages..."
    Message.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_group_memberships
    puts "-- Cleaning Group Memberships..."
    GroupMembership.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_groups
    puts "-- Cleaning Groups..."
    Group.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_users
    puts "-- Cleaning Users..."
    User.destroy_all
    puts "---- Done."
    alt_separator
  end
  
  puts "\n-- Database is now clean.\n\n"
  
  main_separator
end


# ---------------------------------------------


# GENERATE USERS
if seed_users
  puts "CREATING #{users_number} USERS..."
  users_number.times do
    user = User.new
    user.email = Faker::Internet.safe_email
    user.password = 'password'
    user.first_name = Faker::Name.first_name
    user.last_name = Faker::Name.first_name
    user.nickname = "#{user.first_name}_#{rand(1..100)}"
    if user.valid?
      user.save
      puts "-- User saved with email: #{user.email}"
    else
      puts "-- /!/ ERROR: Can't save user. Not valid."
      p user
      errors += 1
    end
  end
  
  puts "\n-- Users are now created.\n\n"
  
  main_separator
end


# ---------------------------------------------


# GENERATE GROUPS
if seed_groups
  puts "CREATING #{groups_number} GROUPS..."
  groups_number.times do
    group = Group.new
    group.title = "#{Faker::Hipster.word.capitalize}#{Faker::Team.creature.capitalize}"
    if group.valid?
      group.save
      puts "-- Group saved with title: #{group.title}"
    else
      puts "-- /!/ ERROR: Can't save group. Not valid."
      p group
      errors += 1
    end

  end
  
  puts "\n-- Groups are now created.\n\n"
  
  main_separator
end


# ---------------------------------------------


# GENERATE GROUP MEMBERSHIPS
if seed_group_memberships
  puts "POPULATING GROUPS WITH USERS..."
  Group.all.each do |group|
    group_size = rand(users_per_group[0]..users_per_group[1])
    group_members = User.all.sample(group_size)
    puts "-- Adding #{group_size} users for group #{group.title}..."
    group_members.each do |group_member|
      group_membership = GroupMembership.new
      group_membership.group = group
      group_membership.user = group_member
      if group_membership.valid?
        group_membership.save
        # Send notification
        if seed_notifications
          notification = Notification.new(user: group_member, importance: 2)
          notification.content = "You have been invited as a member of #{group.title}."
          if notification.valid?
            notification.save
          else
            puts "---- /!/ ERROR: Can't save notification. Not valid."
            p notification
            errors += 1
          end
        end
        puts "---- User #{group_membership.user.nickname} added to group #{group.title}."
      else
        puts "---- /!/ ERROR: Can't save group membership. Not valid."
        p group_membership
        errors += 1
      end
    end
  
  puts "\n-- Groups are now populated.\n\n"
  
  main_separator
end


# ---------------------------------------------


# GENERATE GROUP MESSAGES
if seed_messages
  puts "FLOODING GROUPS WITH MESSAGES..."
  Group.all.each do |group|
    group_members = group.users
    messages_number = rand(messages_per_group[0]..messages_per_group[1])
    puts "-- Sending #{messages_number} messages in group #{group.title}..."
    messages_number.times do
      message = Message.new
      message.group = group
      message.user = group_members.sample
      message.content = Faker::Hipster.sentence
      if message.valid?
        message.save
        puts "---- Message from #{message.user.nickname} sent in group #{group.title}."
        # Send notification
        if seed_notifications
          recipients = message.group
          recipients.each do |recipient|
            notification = Notification.new(user: recipient, importance: 0)
            notification.content = "New message from #{recipient.nickname} in #{group.title}."
            if notification.valid?
              notification.save
            else
              puts "---- /!/ ERROR: Can't save notification. Not valid."
              p notification
              errors += 1
            end
          end
        end
      else
        puts "---- /!/ ERROR: Can't save message. Not valid."
        p message
        errors += 1
      end
    end
  
  puts "\n-- Messages have now been sent.\n\n"
  
  main_separator
end


# ---------------------------------------------


# GENERATE EVENTS
if seed_events
  puts "CREATING EVENTS..."
  Group.all.each do |group|
    events_number = rand(events_per_group[0]..events_per_group[1])
    puts "-- Creating #{events_number} events for group #{group.title}..."
    events_number.times do
      event = Event.new
      event.title = "#{Faker::Verb.base} #{Faker::Name.first_name}"
      event.date = Faker::Date.forward(days: events_max_days_forward)
      event.group = group
      event.city = Faker::Address.city
      event.stage = 1
      if event.valid?
        event.save
        puts "---- Event saved with title: #{event.title}"
      else
        puts "---- /!/ ERROR: Can't save event. Not valid."
        p event
        errors += 1
      end
    end
  
  puts "\n-- Events are now created.\n\n"
  
  main_separator
end


# ---------------------------------------------


# GENERATE EVENT MEMBERSHIPS
if seed_event_memberships
  puts "POPULATING EVENTS WITH USERS..."
  Event.all.each do |event|
    event_group = event.group
    event_members = event_group.users
    puts "-- Adding #{event_members.count} users for event #{event.title}..."
    event_members.each do |event_member|
      event_membership = EventMembership.new
      event_membership.event = event
      event_membership.user = event_member
      event_membership.status = true
      if event_membership.valid?
        event_membership.save
        puts "---- User #{event_membership.user.nickname} added to event #{event.title}."
        # Send notification
        if seed_notifications
          notification = Notification.new(user: event_member, importance: 2)
          notification.content = "You have been invited to this event: #{event.title}."
          if notification.valid?
            notification.save
          else
            puts "---- /!/ ERROR: Can't save notification. Not valid."
            p notification
            errors += 1
          end
        end
      else
        puts "---- /!/ ERROR: Can't save event membership. Not valid."
        p event_membership
        errors += 1
      end
    end
  
  puts "\n-- Events are now populated.\n\n"
  
  main_separator
end


# ---------------------------------------------


# SIMULATE VOTES & STAGING 1 > 2
if seed_votes
  # JUST TO BE SURE
  events_number = Event.all.count
  stage_2_events_number = events_number if stage_2_events_number > events_number
  stage_3_events_number = stage_2_events_number if stage_3_events_number > stage_2_events_number

  puts "SIMULATING STAGE 1 VOTES..."
  # Take a sample of groups of size defined before
  stage_2_events = Group.where(stage: 1).sample(stage_2_events_number)
  # For each event to upstage
  stage_2_events.each do |stage_2_event|
    puts "-- Voting for #{stage_2_event.title}..."
    # Get all its memberships
    stage_2_event_memberships = stage_2_event.group_memberships
    # For each membership
    stage_2_event_memberships.each do |stage_2_event_membership|
      # Generate a vote for each type existing
      vote_types.each do |vote_type|
        vote = Vote.new
        vote.group_membership = stage_2_event_membership
        vote.type = vote_type
        vote.value = vote_values.sample
        if vote.valid?
          vote.save
          puts "---- Vote saved: #{vote.type} => #{vote.value}."
        else
          puts "---- /!/ ERROR: Can't save vote. Not valid."
          p vote
          errors += 1
        end
      end

      # Check Stage 2 conditions
      stage_2_event_votes = stage_2_event.votes.count
      stage_2_event_users = stage_2_event.users.count
      if stage_2_event_votes >= stage_2_event_users
        # Upgrade to stage 2
        stage_2_event.stage = 2
        # Pick the random user
        stage_2_event.random_user = stage_2_event.users.sample
        # Save
        stage_2_event.update
        puts "---- #{stage_2_event.title} updated to Stage 2."
        puts "---- #{stage_2_event.random_user.nickname} has to make the booking."

        # Send notification
        if seed_notifications
          stage_2_event_users.each do |u|
            notification = Notification.new(user: u, importance: 1)
            notification.content = "Votes session for #{stage_2_event.title} is complete!"
            if notification.valid?
              notification.save
            else
              puts "------ /!/ ERROR: Can't save notification. Not valid."
              p notification
              errors += 1
            end
          end
        end
      else
        puts "---- /!/ ERROR: Can't update event '#{stage_2_event.title}' to Stage 2."
        p stage_2_event
        p stage_2_event.votes
        errors += 1
      end
    end
  end
end


# ---------------------------------------------


# CALLING YELP API FOR EVENT PLACES
if seed_event_places
  stage_2_events = Event.where(stage: 2)
  # Compile votes for each one
  stage_2_events.each do |stage_2_event|
    compiled_votes = {}
    stage_2_event.votes.each do |vote|
      vote.value = 0 if vote.value.nil?
      compiled_votes[vote.type] += vote.value
    end
    stage_2_event_term = compiled_votes.max_by { |type, value| value }[0]

    stage_2_event_places = Yelp.search(stage_2_event_term, stage_2_event.city)[:businesses]
    # Initialize rank
    rank = 1
    stage_2_event_places.each do |stage_2_event_place|
      place = EventPlace.new
      place.event = stage_2_event
      place.yelp_name = stage_2_event_place["name"]
      place.yelp_id = stage_2_event_place["id"]
      place.yelp_price = stage_2_event_place["price"]
      place.yelp_longitude = stage_2_event_place["coordinates"]["longitude"]
      place.yelp_latitude = stage_2_event_place["coordinates"]["latitude"]
      place.yelp_phone = stage_2_event_place["phone"]
      place.yelp_address1 = stage_2_event_place["location"]["address1"]
      place.yelp_address2 = stage_2_event_place["location"]["address2"]
      place.yelp_address3 = stage_2_event_place["location"]["address3"]
      place.yelp_city = stage_2_event_place["location"]["city"]
      place.yelp_country = stage_2_event_place["location"]["country"]
      place.yelp_zip_code = stage_2_event_place["location"]["zip_code"]
      place.yelp_state = stage_2_event_place["location"]["state"]
      place.yelp_url = stage_2_event_place["url"]
      place.yelp_image_url = stage_2_event_place["image_url"]
      place.yelp_rating = stage_2_event_place["rating"]
      place.yelp_review_count = stage_2_event_place["review_count"]
      place.rank = rank
      rank += 1
      # Try to save it
      if place.valid?
        place.save
        puts "---- Yelp Event Place saved: #{place.yelp_name}."
      else
        puts "---- /!/ ERROR: Can't save Yelp Event Place. Not valid."
        p place
        errors += 1
      end
    end
  end
end


# ---------------------------------------------



puts "END OF SEED - #{errors} error(s)."

main_separator

puts "Here are the last #{last_users_number} user accounts for accessing the website:"
last_users = User.last(last_users_number)
last_users.each do |u|
  puts "-- #{u.email} (password: 'password')"
end