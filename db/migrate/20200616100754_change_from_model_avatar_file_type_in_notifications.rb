class ChangeFromModelAvatarFileTypeInNotifications < ActiveRecord::Migration[6.0]
  def change
    change_column :notifications, :from_model_avatar_file, :string
  end
end
