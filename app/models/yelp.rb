class Yelp
  require "json"
  require "http"

  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/businesses/search"
  BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
  SEARCH_LIMIT = 20
  API_KEY = ENV["YELP_API_KEY"]

  def self.search(term, location)
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
      term: term,
      location: location,
      limit: SEARCH_LIMIT
    }

    response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
    response.parse
  end

  def self.business(business_id)
    url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}"

    response = HTTP.auth("Bearer #{API_KEY}").get(url)
    response.parse
  end

  def self.fetch_places(event)
    rank = 1
    event_places = Yelp.search(event.term, event.city)["businesses"]

    if !event_places.nil?
      event_places.each do |event_place|
        place = EventPlace.new
        place.event = event
        place.booking_status = "pending"
        place.yelp_name = event_place["name"]
        place.yelp_alias = event_place["alias"]
        place.yelp_id = event_place["id"]
        place.yelp_price = event_place["price"]
        place.yelp_longitude = event_place["coordinates"]["longitude"]
        place.yelp_latitude = event_place["coordinates"]["latitude"]
        place.yelp_phone = event_place["phone"]
        place.yelp_address1 = event_place["location"]["address1"]
        place.yelp_address2 = event_place["location"]["address2"]
        place.yelp_address3 = event_place["location"]["address3"]
        place.yelp_city = event_place["location"]["city"]
        place.yelp_country = event_place["location"]["country"]
        place.yelp_zip_code = event_place["location"]["zip_code"]
        place.yelp_state = event_place["location"]["state"]
        place.yelp_url = event_place["url"]
        place.yelp_image_url = event_place["image_url"]
        if event_place["image_url"] == "" || event_place["image_url"].nil? || event_place["image_url"].empty?
          place.yelp_image_url = nil
        else
          place.yelp_image_url = event_place["image_url"]
        end
        place.yelp_rating = event_place["rating"]
        place.yelp_review_count = event_place["review_count"]
        place.rank = rank
        rank += 1
        # Try to save it
        if place.valid?
          place.save
        else
          puts "---- /!/ ERROR: Can't save place #{place.yelp_name}. Not valid."
        end
      end
    else
      p "Can't find results for '#{event.term}' in #{event.city}"
    end
  end
end