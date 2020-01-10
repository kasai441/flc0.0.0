class AddNameIndexToQuizcards < ActiveRecord::Migration[5.1]
  def change
    # add_index :quizcards, [:name, :user_id], unique: true
    add_index :waitdays, [:wait_sequence, :quizcard_id], unique: true
  end
end
