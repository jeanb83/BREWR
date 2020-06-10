class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.date :date
      t.references :group, null: false, foreign_key: true
      t.string :city
      t.integer :stage

      t.timestamps
    end
  end
end
