
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
      params do
        optional :date_month, type: String
        optional :after, type: Integer
      end
      get 'timeline_monthly' do
        authenticate!
        date_month = Date.parse(params[:date_month] || 1.month.ago.to_date.to_s).to_date.beginning_of_month
        sleep_aggregated = MonthlySleep.where(month: date_month).from_user(current_user).after(params[:after])

        present CursorArray.new(sleep_aggregated), with: Entities::WithCursor, entry: Entities::MonthSleep
      end
    end
  end
end
