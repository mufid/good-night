class CreateMonthlySleeps < ActiveRecord::Migration[8.0]
  def change
    create_table :monthly_sleeps do |t|
      t.belongs_to :user
      t.date :month
      t.integer :duration_minutes
      t.integer :sleeps_count
      t.timestamps
    end

    add_index :monthly_sleeps, [:user_id, :month], unique: true
  end
end
