module Goodnight::V202509::Entities
  class WithCursor < Grape::Entity
    expose :data do |instance, options|
      options[:entry].represent(instance.data)
    end
    expose :has_more
    expose :next_timestamp
  end
end
