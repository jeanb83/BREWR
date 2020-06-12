class Avatar

  EVENT_AVATARS = ['sushi', 'hot-dog', 'ice-cream',
                   'lobster', 'coffee-cup', 'donut',
                   'egg', 'hamburger', 'chef']

  GROUP_AVATARS = ['037-pizza', '026-ice-cream', '025-tea',
                   '021-food', '018-disco', '016-cooking-pot',
                   '015-cocktail', '012-cafe', '006-bbq']

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
