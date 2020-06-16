class RenameFromModelRefToAvatarInNotifications < ActiveRecord::Migration[6.0]
  def change
    rename_column :notifications, :from_model_ref, :from_model_avatar_file
  end
end
