class MonthlySleepGeneratorJob < ApplicationJob
  def perform(user_id, month)
    date = Date.parse(month)
    user = User.find(user_id)
    MonthlySleepAggregatorService.new(user, date).regenerate
  end
end
