class MonthlySleepAggregatorService

  attr_accessor :user, :date
  def initialize(user, date)
    @user = user
    @date = date
  end
  def regenerate
    user_id = user.id.to_i
    date_to_s = date.beginning_of_month.to_s
    record = MonthlySleep.find_or_create_by(user_id: user.id, month: date.beginning_of_month)
    sql = <<-SQL
        SELECT
          coalesce(count(*), 0) as sleeps_count,
          coalesce(sum(duration_minutes), 0) as duration_minutes
        FROM sleeps
        WHERE
          user_id = #{user_id} AND
          cast(date_trunc('month', clocked_in_at) as date) = '#{date_to_s}' AND
          duration_minutes > 0
        GROUP BY user_id
    SQL

    to_update = ActiveRecord::Base.connection.execute(sql).first

    record.update(to_update) if !to_update.nil?
  end
end
