class CreateSleeps < ActiveRecord::Migration[8.0]
  def change
    create_table :sleeps do |t|
      t.belongs_to :user
      t.datetime :clocked_in_at
      t.datetime :clocked_out_at
      t.integer :duration_minutes

      t.timestamps
    end

    add_index :sleeps, :clocked_in_at
    add_index :sleeps, :clocked_out_at
    add_index :sleeps, [:user_id, :clocked_in_at, :duration_minutes]
    add_index :sleeps, :user_id, unique: true, where: 'clocked_out_at IS NULL', name: 'index_sleeps_ensure_single_active_session'

  end
end
