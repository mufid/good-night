class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 127 }
end
