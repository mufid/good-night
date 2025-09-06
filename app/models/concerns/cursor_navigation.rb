module CursorNavigation
  extend ActiveSupport::Concern
  included do
    class_attribute :cursor_field
    class_attribute :cursor_type

    scope :after, -> (ts) do
      if ts.blank?
        order("#{cursor_field} desc").limit(default_limit).where("1=1")
      else
        pointer =
          if cursor_type == Integer
            ts
          else
            Time.at(ts)
          end

        order("#{cursor_field} desc").limit(default_limit).where("#{cursor_field} < ?", pointer)
      end
    end
  end
end
