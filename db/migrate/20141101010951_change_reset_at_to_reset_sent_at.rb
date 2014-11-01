class ChangeResetAtToResetSentAt < ActiveRecord::Migration
  def change
    rename_column :users, :reset_at, :reset_sent_at
  end
end
