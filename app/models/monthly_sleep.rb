class MonthlySleep < ApplicationRecord
  include CursorNavigation

  belongs_to :user

  scope :from_user, -> (current_user) do
    where("user_id IN (SELECT user_following_id FROM user_followings WHERE user_id=#{current_user.id.to_i})")
  end

  self.cursor_field = :id
  self.cursor_type = Integer
end
