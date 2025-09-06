module Sleeps
  class ClockOut
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :sleep
    def save
      if (Time.zone.now - sleep.clocked_in_at).to_i < 60
        errors.add(:base, :minimum_sleep_one_minute)
        return false
      end
      updated_rows =
        Sleep.where(id: sleep.id)
             .where(clocked_out_at: nil)
             .update_all(
               clocked_out_at: Time.zone.now,
               week: Arel.sql("extract('week' from clocked_in_at)"),
               year: Arel.sql("extract('year' from clocked_in_at)")
             )

      sleep.reload
      sleep.ensure_duration
      sleep.save

      if updated_rows == 0
        errors.add(:base, :already_clocked_out)
        return false
      end

      true
    end
  end
end
