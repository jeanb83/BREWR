class AddRandomUserIdToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :random_user_id, :integer
  end
end
