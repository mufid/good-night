
module Goodnight::V202509
  class Sleeps < ::Goodnight::ApplicationAPI
    resources :sleeps do
      post 'clock_in' do
        authenticate!
        clock_in = ::Sleeps::ClockIn.new(user: current_user)
        return failure_with_data(clock_in) if !clock_in.save

        status :created
        present clock_in.sleep, with: Entities::Sleep
      end

      get 'current' do
        authenticate!
        sleep = current_user.sleeps.in_progress.take!
        present sleep, with: Entities::Sleep
      end

      route_param :id do
        post 'clock_out' do
          to_be_implemented!
        end
      end

    end
  end
end
