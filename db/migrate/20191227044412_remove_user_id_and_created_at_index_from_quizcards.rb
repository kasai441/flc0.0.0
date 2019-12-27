class RemoveUserIdAndCreatedAtIndexFromQuizcards < ActiveRecord::Migration[5.1]
  def change
    remove_index :quizcards, [:user_id, :created_at]
  end
end
