# REQUIRES

# SEED VARIABLES
# Users variables
users_number = 45
# Groups variables
groups_number = 23
# Group Memberships variables
users_per_group = [2, 8]
# Messages variables
messages_per_group = [3, 18]
# Events variables
events_per_group = [2, 4]
events_max_days_forward = 20
# Votes variables
stage_2_events_number = 14 # Inferior to minimum events_number * groups_number !
stage_3_events_number = 8 # Inferior to stage_2_events_number !
vote_tastes = Vote.get_vote_tastes
vote_likes = [-100, 0, 1]
# General seed variables
last_users_number = 10 # Number of user emails to display at the end to access the website
errors = 0 # Starting errors counter

# OPTIONS
# Users
clean_users = true
seed_users = true
# Groups (requires users in db!)
clean_groups = true
seed_groups = true
# Group Memberships (requires groups & users in db!)
clean_group_memberships = true
seed_group_memberships = true
# Messages (requires groups & users in db!)
clean_messages = true
seed_messages = true
# Events (requires groups & users in db!)
clean_events = true
seed_events = true
# Event Memberships (requires groups & users in db!)
clean_event_memberships = true
seed_event_memberships = true
# Votes (requires groups & users & events in db!)
clean_votes = true
seed_votes = true
# Notifications (requires users in db!)
clean_notifications = true
seed_notifications = true
# Database
clean_database = true

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

  if clean_notifications == true
    puts "-- Cleaning Notifications..."
    Notification.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_event_places == true
    puts "-- Cleaning Event Places..."
    EventPlace.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_votes == true
    puts "-- Cleaning Votes..."
    Vote.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_event_memberships == true
    puts "-- Cleaning Event Memberships..."
    EventMembership.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_events == true
    puts "-- Cleaning Events..."
    Event.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_messages == true
    puts "-- Cleaning Messages..."
    Message.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_group_memberships == true
    puts "-- Cleaning Group Memberships..."
    GroupMembership.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_groups == true
    puts "-- Cleaning Groups..."
    Group.destroy_all
    puts "---- Done."
    alt_separator
  end

  if clean_users == true
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
    user.avatar_file = "avatars/users/#{Avatar.get_user_avatars.sample}.svg"
    if user.valid?
      user.save
      puts "-- User saved with email: #{user.email} (password: 'password')"
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
    group.avatar_file = "avatars/groups/#{Avatar.get_group_avatars.sample}.svg"
    if group.valid?
      group.save
      puts "-- Group saved with title: '#{group.title}'"
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
    puts "-- Adding #{group_size} users for Group '#{group.title}'..."
    group_members.each do |group_member|
      group_membership = GroupMembership.new
      group_membership.group = group
      group_membership.user = group_member
      if group_membership.valid?
        group_membership.save
        # Send notification
        if seed_notifications
          notification = Notification.new(user: group_member, from_model: "group", from_model_avatar_file: group.avatar_file)
          notification.content = "You have been invited as a member of #{group.title}."
          if notification.valid?
            notification.save
          else
            puts "---- /!/ ERROR: Can't save notification. Not valid."
            p notification
            errors += 1
          end
        end
        puts "----  #{group.title}: User #{group_membership.user.nickname} added to group."
      else
        puts "---- /!/ ERROR: Can't save group membership. Not valid."
        p group_membership
        errors += 1
      end
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
    puts "-- Sending #{messages_number} messages in Group '#{group.title}'..."
    messages_number.times do
      message = Message.new
      message.group = group
      message.user = group_members.sample
      message.content = Faker::Hipster.sentence
      if message.valid?
        message.save
        puts "---- Group '#{group.title}': Message from User '#{message.user.nickname}' sent in group."
        # Send notification
        if seed_notifications
          recipients = message.group.users
          recipients.each do |recipient|
            notification = Notification.new(user: recipient, from_model: "user", from_model_avatar_file: message.user.avatar_file)
            notification.content = "New message from User '#{message.user.nickname}' in Group '#{group.title}'."
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
    puts "-- Creating #{events_number} events for Group '#{group.title}'..."
    events_number.times do
      event = Event.new
      event.title = "#{Faker::Verb.base.capitalize} #{Faker::Name.first_name}"
      event.date = Faker::Date.forward(days: events_max_days_forward)
      event.group = group
      event.city = Faker::Address.city
      event.avatar_file = "avatars/events/#{Avatar.get_event_avatars.sample}.svg"
      event.stage = 1
      if event.valid?
        event.save
        puts "---- Event saved with title: '#{event.title}'"
      else
        puts "---- /!/ ERROR: Can't save event. Not valid."
        p event
        errors += 1
      end
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
    puts "-- Adding #{event_members.count} users for Event '#{event.title}'..."
    event_members.each do |event_member|
      event_membership = EventMembership.new
      event_membership.event = event
      event_membership.user = event_member
      event_membership.status = true
      if event_membership.valid?
        event_membership.save
        puts "---- Event '#{event.title}': User '#{event_membership.user.nickname}' added to event."
        # Send notification
        if seed_notifications
          notification = Notification.new(user: event_member, from_model: "event", from_model_avatar_file: event.avatar_file)
          notification.content = "You have been invited to this event: '#{event.title}' on #{event.date.strftime("%b %d")}."
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
  # Take a sample of events of size defined before
  stage_2_events = Event.where(stage: 1).sample(stage_2_events_number)
  # For each event to upstage
  stage_2_events.each do |stage_2_event|
    # Get all its memberships
    stage_2_event_memberships = stage_2_event.event_memberships
    # For each membership
    stage_2_event_memberships.each do |stage_2_event_membership|
      puts "-- Voting for Event '#{stage_2_event.title}' by User '#{stage_2_event_membership.user.nickname}'..."
      # Generate a vote for each type existing
      vote_tastes.each do |vote_taste|
        vote = Vote.new
        vote.event_membership = stage_2_event_membership
        vote.taste = vote_taste
        vote.like = vote_likes.sample
        if vote.valid?
          vote.save
          print "#{vote.taste} => #{vote.like}"
        else
          puts "---- /!/ ERROR: Can't save vote. Not valid."
          p vote
          errors += 1
        end
      end
    end
    # Check Stage 2 conditions
    stage_2_event_votes = stage_2_event.votes.count
    stage_2_event_users = stage_2_event.users.count
    if stage_2_event_votes >= stage_2_event_users
      # Upgrade to stage 2
      stage_2_event.stage = 2
      # Pick the random user
      rand_user = stage_2_event.users.sample
      stage_2_event.random_user_id = rand_user
      # Save
      stage_2_event.save
      puts "\n\n---- Event '#{stage_2_event.title}' updated to Stage 2."
      puts "---- User '#{rand_user.nickname}' has to make the booking.\n\n"

      # Send notification
      if seed_notifications
        stage_2_event.users.each do |u|
          notification = Notification.new(user: u, from_model: "event", from_model_avatar_file: stage_2_event.avatar_file)
          notification.content = "Voting session for #{stage_2_event.title} is complete! #{rand_user.nickname} will now make the booking."
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


# ---------------------------------------------


# CALLING YELP API FOR EVENT PLACES
if seed_event_places
  stage_2_events = Event.where(stage: 2)
  # Compile votes for each one
  stage_2_events.each do |stage_2_event|
    compiled_votes = {}
    # Initialize all tastes to 0
    vote_tastes.each do |vote_taste|
      compiled_votes[vote_taste] = 0
    end
    # Compile the votes
    stage_2_event.votes.each do |vote|
      compiled_votes[vote.taste] += vote.like
    end
    # Get the bigger vote
    stage_2_event_term = compiled_votes.max_by { |taste, like| like }[0]
    puts "\n\nEvent @#{stage_2_event.title}: Winning term: '#{stage_2_event_term}'"

    puts "\n\n> Calling Yelp API with term '#{stage_2_event_term}' and city '#{stage_2_event.city}'"

    stage_2_event_places = Yelp.search(stage_2_event_term, stage_2_event.city)["businesses"]
    if stage_2_event_places.nil?
      puts "-- No API from Yelp :(\n\n"
    else
      puts "-- Got API response from Yelp :)\n\n"
    end
    # Initialize rank
    if stage_2_event_places
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
end


# ---------------------------------------------



puts "\n\nEND OF SEED - #{errors} error(s)."

main_separator

puts "Here are the last #{last_users_number} user accounts for accessing the website:"
last_users = User.last(last_users_number)
last_users.each do |u|
  puts "-- #{u.nickname}: #{u.email} (password: 'password')"
  puts "---- Groups: #{u.groups.count}"
  puts "---- Events : #{u.events.count}"
  puts "---- Stage 2 : #{u.events.where(stage: 2).count ? u.events.where(stage: 2).count : 0}\n\n"
end
puts "\n\n"