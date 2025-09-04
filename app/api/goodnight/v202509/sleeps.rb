
module Goodnight::V202509
  class Sleeps < ::Goodnight::ApplicationAPI
    resources :sleeps do
      desc 'Clock in for sleeping. Notice: You must clock out previous sleep (if any) before clocking in for new sleep'
      post 'clock_in' do
        authenticate!
        clock_in = ::Sleeps::ClockIn.new(user: current_user)
        return failure_with_data(clock_in) if !clock_in.save

        status :created
        present clock_in.sleep, with: Entities::Sleep
      end

      desc 'Get current clocked-in sleep (if any)'
      get 'current' do
        to_be_implemented!
      end

      route_param :id do
        post 'clock_out' do
          to_be_implemented!
        end
      end
    end
  end
end
