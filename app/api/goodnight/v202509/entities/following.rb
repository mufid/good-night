module Goodnight::V202509::Entities
  class Following < Grape::Entity
    expose :user_following_id, as: :id
    expose :name do |object, _|
      object.user_following.name
    end
  end
end
