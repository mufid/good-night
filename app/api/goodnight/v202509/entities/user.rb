module Goodnight::V202509::Entities
  class User < Grape::Entity
    expose :id
    expose :name
  end
end
