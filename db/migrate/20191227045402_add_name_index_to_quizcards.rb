class AddNameIndexToQuizcards < ActiveRecord::Migration[5.1]
  def change
    add_index :quizcards, [:name, :user_id], unique: true
  end
end
