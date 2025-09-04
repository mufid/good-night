module Sleeps
  class ClockIn
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :user
    attribute :sleep
    def save
      ActiveRecord::Base.transaction do
        ulocked = User.lock.find(user.id)
        errors.add(:base, :sleep_in_progress) if ulocked.sleeps.in_progress.exists?
        return false if errors.any?

        self.sleep = ulocked.sleeps.create(
          clocked_in_at: Time.zone.now,
          duration_minutes: 0,
        )

        ulocked.touch
      end

      true
    end
  end
end
