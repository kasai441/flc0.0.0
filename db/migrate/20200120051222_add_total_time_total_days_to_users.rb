class AddTotalTimeTotalDaysToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :total_time, :integer
    add_column :users, :practice_days, :integer
    add_column :users, :last_practiced_at, :datetime
    add_column :users, :total_practices, :integer
  end
end
