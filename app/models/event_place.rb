class EventPlace < ApplicationRecord
  belongs_to :event

  validates :rank, presence: true
  validates :yelp_name, presence: true
  validates :yelp_alias, presence: true
  validates :yelp_phone, presence: true
  validates :yelp_url, presence: true
  validates :yelp_image_url, presence: true
  validates :yelp_address1, presence: true
  validates :yelp_city, presence: true
  validates :yelp_country, presence: true

  def yelp_geocoded?
    @yelp_longitude.nil? || @yelp_latitude.nil? ? false : true
  end
end
