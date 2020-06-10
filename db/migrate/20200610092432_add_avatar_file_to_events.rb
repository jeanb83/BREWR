class AddAvatarFileToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :avatar_file, :string
  end
end
