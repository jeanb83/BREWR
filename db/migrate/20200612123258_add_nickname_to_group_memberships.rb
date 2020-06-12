class AddNicknameToGroupMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :group_memberships, :nickname, :string
  end
end
