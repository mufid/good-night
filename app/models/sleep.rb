class Sleep < ApplicationRecord
  belongs_to :user, required: true

  scope :in_progress, -> { where(clocked_out_at: nil) }

  before_validation :ensure_duration

  def ensure_duration
    return true if clocked_out_at.blank?
    self.duration_minutes = (clocked_out_at - clocked_in_at).to_i / 60
    true
  end
end
