class CursorArray
  attr_accessor :data
  attr_accessor :has_more
  attr_accessor :next_timestamp
  def initialize(data)
    self.data = data.to_a

    data_klazz =
      if self.data.any?
        self.data.first.class
      else
        nil
      end

    if data_klazz.nil?
      self.has_more = false
      self.next_timestamp = nil
      return
    end

    cursor = self.data.last.send(data_klazz.cursor_field).to_i

    if data.after(cursor).any?
      self.has_more = true
      self.next_timestamp = cursor
    else
      self.has_more = false
      self.next_timestamp = nil
    end
  end
end
