module Sleeps
  class ClockOut
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :sleep
    def save
      updated_rows =
        Sleep.where(id: sleep.id)
             .where(clocked_out_at: nil)
             .update_all(clocked_out_at: Time.zone.now)

      sleep.reload

      if updated_rows == 0
        errors.add(:base, 'Tried to clock out a sleep that has been already clocked out!')
        return false
      end

      true
    end
  end
end
