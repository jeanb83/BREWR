class AddLinkToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :from_model_link, :string
  end
end
