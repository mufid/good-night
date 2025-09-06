module UserFollowings
  class Unfollow
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :current_user
    attribute :user_to_unfollow

    def save
      affected_rows =
        UserFollowing.where(user_id: current_user.id, user_following_id: user_to_unfollow.id)
                     .delete_all

      if affected_rows == 0
        errors.add(:base, :already_unfollowed_or_invalid)
        return false
      end

      true
    end
  end
end
