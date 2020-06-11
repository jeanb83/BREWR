class ChangeTypeToTasteInVotes < ActiveRecord::Migration[6.0]
  def change
    rename_column :votes, :type, :taste
    rename_column :votes, :value, :like
  end
end
