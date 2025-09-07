class MonthlySleepAggregatorJob < ApplicationJob
  def perform(month = 1.month.ago.to_date.to_s)
    jobs = User.pluck(:id).map do |user_id|
      MonthlySleepGeneratorJob.new(user_id, month)
    end
    ActiveJob.perform_all_later(jobs)
  end
end
