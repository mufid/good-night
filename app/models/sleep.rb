class Sleep < ApplicationRecord
  belongs_to :user, required: true

  scope :in_progress, -> { where(clocked_out_at: nil) }

end
