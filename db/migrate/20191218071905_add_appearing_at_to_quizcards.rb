class AddAppearingAtToQuizcards < ActiveRecord::Migration[5.1]
  def change
    add_column :quizcards, :appearing_at, :datetime, after: :origin
    add_index :quizcards, [:appearing_at]
  end
end
