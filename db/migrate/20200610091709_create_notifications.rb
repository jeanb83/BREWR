class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.integer :importance

      t.timestamps
    end
  end
end
