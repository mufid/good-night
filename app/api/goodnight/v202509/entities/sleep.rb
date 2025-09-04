module Goodnight::V202509::Entities
  class Sleep < Grape::Entity
    expose :id
    expose :clocked_in_at
    expose :clocked_out_at
    expose :duration_minutes
  end
end
