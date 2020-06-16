class AddAliasToEventPlaces < ActiveRecord::Migration[6.0]
  def change
    add_column :event_places, :yelp_alias, :string
  end
end
