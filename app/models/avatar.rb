class Avatar

  EVENT_AVATARS = ['sushi', 'hot-dog', 'ice-cream',
                   'lobster', 'coffee-cup', 'donut',
                   'egg', 'hamburger', 'chef']

  GROUP_AVATARS = ['pizza', 'ice-cream', 'tea',
                   'food', 'disco', 'cooking-pot',
                   'cocktail', 'cafe', 'bbq']

  USER_AVATARS = ['superheroe', 'superheroe-1', 'spy',
                   'queen', 'man-1', 'king',
                   'girl', 'chef', 'boy']

  def self.get_event_avatars
    EVENT_AVATARS
  end

  def self.get_group_avatars
    GROUP_AVATARS
  end

  def self.get_user_avatars
    USER_AVATARS
  end
end
