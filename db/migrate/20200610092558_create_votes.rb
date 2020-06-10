class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :event_membership, null: false, foreign_key: true
      t.string :type
      t.integer :value

      t.timestamps
    end
  end
end
