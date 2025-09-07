module Goodnight::V202509::Entities
  class MonthSleep < Grape::Entity
    expose :month
    expose :user_id
    expose :duration_minutes
    expose :sleeps_count
  end
end
