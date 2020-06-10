class CreateEventPlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :event_places do |t|
      t.references :event, null: false, foreign_key: true
      t.string :yelp_id
      t.integer :rank
      t.boolean :booking_status
      t.string :yelp_name
      t.string :yelp_price
      t.float :yelp_longitude
      t.float :yelp_latitude
      t.string :yelp_phone
      t.integer :yelp_rating
      t.integer :yelp_review_count
      t.string :yelp_url
      t.string :yelp_image_url
      t.string :yelp_address1
      t.string :yelp_address2
      t.string :yelp_address3
      t.string :yelp_city
      t.string :yelp_zip_code
      t.string :yelp_state
      t.string :yelp_country

      t.timestamps
    end
  end
end
