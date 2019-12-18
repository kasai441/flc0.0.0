class CreateWaitdays < ActiveRecord::Migration[5.1]
  def change
    create_table :waitdays do |t|
      t.string :wait_sequence
      t.string :wait_day
      t.references :quizcard, foreign_key: true

      t.timestamps
    end
    add_index :waitdays, [:quizcard_id, :created_at]
  end
end
