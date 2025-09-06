class UserFollowing < ApplicationRecord
  include CursorNavigation

  belongs_to :user
  belongs_to :user_following, class_name: 'User'

  self.cursor_field = :id
  self.cursor_type = Integer
end
