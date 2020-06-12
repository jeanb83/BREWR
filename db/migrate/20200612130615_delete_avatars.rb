class DeleteAvatars < ActiveRecord::Migration[6.0]
  def change
    drop_table :avatars
  end
end
