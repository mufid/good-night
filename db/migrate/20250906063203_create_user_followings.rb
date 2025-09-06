class CreateUserFollowings < ActiveRecord::Migration[8.0]
  def change
    create_table :user_followings do |t|
      t.belongs_to :user
      t.belongs_to :user_following, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :user_followings, [:user_id, :user_following_id], unique: true
  end
end
