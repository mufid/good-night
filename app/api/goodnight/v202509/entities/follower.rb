module Goodnight::V202509::Entities
  class Follower < Grape::Entity
    expose :user_id, as: :id
    expose :name do |object, _|
      object.user.name
    end
  end
end
