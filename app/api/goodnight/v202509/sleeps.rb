
module Goodnight::V202509
  class Sleeps < ::Goodnight::ApplicationAPI
    resources :sleeps do
      params do
        optional :after, type: Integer
      end
      get do
        authenticate!
        sleeps = current_user.sleeps.after(params[:after])
        present CursorArray.new(sleeps), with: Entities::WithCursor, entry: Entities::Sleep
      end

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
          authenticate!
          sleep = current_user.sleeps.in_progress.where(id: params[:id]).take!
          clock_out = ::Sleeps::ClockOut.new(sleep: sleep)
          return failure_with_data(clock_out) if !clock_out.save

          status :ok
          present sleep, with: Entities::Sleep
        end

        get do
          authenticate!
          sleep = current_user.sleeps.where(id: params[:id]).take!

          status :ok
          present sleep, with: Entities::Sleep
        end
      end

    end
  end
end
