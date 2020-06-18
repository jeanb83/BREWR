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
vote_tastes = Vote.get_vote_tastes
vote_likes = [-100, 0, 1]
# General seed variables
last_users_number = 10 # Number of user emails to display at the end to access the website
errors = 0 # Starting errors counter

# OPTIONS
# Users
clean_users = true
seed_users = false
# Groups (requires users in db!)
clean_groups = true
seed_groups = false
# Group Memberships (requires groups & users in db!)
clean_group_memberships = true
seed_group_memberships = false
# Messages (requires groups & users in db!)
clean_messages = true
seed_messages = false
# Events (requires groups & users in db!)
clean_events = true
seed_events = false
# Event Memberships (requires groups & users in db!)
clean_event_memberships = true
# Votes (requires groups & users & events in db!)
clean_votes = true
seed_votes = false
# Notifications (requires users in db!)
clean_notifications = true
seed_notifications = false
# Database
clean_database = true

# Event Places
clean_event_places = true



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
if seed_users == true
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
if seed_groups == true
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
if seed_group_memberships == true
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
          Notification.new_group_member(group_membership)
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
if seed_messages == true
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
          Notification.new_group_message(message)
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
if seed_events == true
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
      # Send notification
      if seed_notifications
        Notification.new_event(event)
      end
    end
  end
  puts "\n-- Events are now created.\n\n"
  
  main_separator
end


# ---------------------------------------------


# SIMULATE VOTES & STAGING 1 > 2
if seed_votes == true
  # JUST TO BE SURE
  events_number = Event.all.count
  stage_2_events_number = events_number if stage_2_events_number > events_number

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
          puts "---- #{stage_2_event_membership.user.nickname} voted : #{vote.taste} => #{vote.like}"
        else
          puts "---- /!/ ERROR: Can't save vote. Not valid."
          p vote
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