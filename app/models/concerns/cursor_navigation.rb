module CursorNavigation
  DEFAULT_LIMIT = 1
  extend ActiveSupport::Concern
  included do
    class_attribute :cursor_field

    scope :after, -> (ts) do
      if ts.blank?
        order("#{cursor_field} desc").limit(DEFAULT_LIMIT).where("1=1")
      else
        order("#{cursor_field} desc").limit(DEFAULT_LIMIT).where("#{cursor_field} < ?", Time.at(ts))
      end
    end
  end
end