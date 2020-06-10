class AddAvatarFileToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :avatar_file, :string
  end
end
