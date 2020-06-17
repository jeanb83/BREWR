class ChangeBookingStatusTypeInEventPlaces < ActiveRecord::Migration[6.0]
  def change
    change_column :event_places, :booking_status, :string
  end
end
