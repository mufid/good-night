class AddYearAndWeekToSleeps < ActiveRecord::Migration[8.0]
  def change
    add_column :sleeps, :year, :integer
    add_column :sleeps, :week, :integer

    add_index :sleeps, [:year, :week, :duration_minutes, :user_id]
  end
end
