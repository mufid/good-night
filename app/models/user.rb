class User < ApplicationRecord
  has_many :sleeps
  validates :name, presence: true, length: { maximum: 127 }
end
