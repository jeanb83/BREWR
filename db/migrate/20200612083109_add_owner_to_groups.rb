class AddOwnerToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :owner_id, :integer
  end
end
