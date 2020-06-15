class AddTermToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :term, :string
  end
end
