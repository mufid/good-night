
module Goodnight::V202509
  class Timelines < ::Goodnight::ApplicationAPI
    resources :users do
      params do
        optional :date_week, type: String
        optional :after, type: String
      end
      get 'timeline' do
        authenticate!
        date_week = params[:date_week] || Time.zone.now.to_date.to_s
        sleeps = SleepTimeline.where('duration_minutes > 0').from_user(current_user).date_week(date_week).after(params[:after])
        puts sleeps.explain(:analyze, :verbose).inspect
        present CursorArray.new(sleeps), with: Entities::WithCursor, entry: Entities::Sleep
      end
    end
  end
end
