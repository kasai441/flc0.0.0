class AddAppearingAtToWaitdays < ActiveRecord::Migration[5.1]
  def change
    add_column :waitdays, :appearing_at, :datetime
    add_index :waitdays, [:appearing_at]
  end
end
