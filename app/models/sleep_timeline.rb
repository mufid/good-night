class SleepTimeline < Sleep
  class SortKey
    def self.split(key)
      key.split('-').map(&:to_i)
    end
  end

  self.cursor_field = :timeline_cursor
  self.cursor_type = :custom

  scope :from_user, -> (current_user) do
    where("user_id IN (SELECT user_following_id FROM user_followings WHERE user_id=#{current_user.id.to_i})")
  end

  scope :date_week, -> (dw) do
    date = Date.parse(dw)
    where(year: date.year, week: date.cweek)
  end

  scope :after, -> (key) do
    if key.blank?
      order("duration_minutes desc").order("id desc")
                                    .limit(default_limit)
                                    .where("1=1")
    else
      id, duration_minutes = SortKey.split(key)
      order("duration_minutes desc").order("id desc")
                                    .limit(default_limit)
                                    .where("(duration_minutes = #{duration_minutes.to_i} AND id < #{id.to_i}) OR (duration_minutes < #{duration_minutes.to_i})")
    end
  end

  def timeline_cursor
    "#{id}-#{duration_minutes}"
  end
end