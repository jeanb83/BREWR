class AddTopicAndTopicRefToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :from_model, :string
    add_column :notifications, :from_model_ref, :integer
  end
end
