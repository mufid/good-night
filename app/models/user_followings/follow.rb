module UserFollowings
  class Follow
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :current_user
    attribute :user_to_follow

    def save
      if current_user.id == user_to_follow.id
        errors.add(:base, :can_not_follow_self)
        return false
      end
      UserFollowing.create(user_id: current_user.id, user_following_id: user_to_follow.id)
    rescue ActiveRecord::RecordNotUnique
      errors.add(:base, :already_followed)
      false
    end
  end
end
