class CreateQuizcards < ActiveRecord::Migration[5.1]
  def change
    create_table :quizcards do |t|
      t.string :fail_seq
      t.text :description
      t.datetime :registered_at
      t.string :name
      t.string :connotation
      t.string :pronunciation
      t.string :origin
      t.decimal :wait_seconds
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :quizcards, [:user_id, :created_at]
  end
end
