class User < ApplicationRecord
  has_many :sleeps

  has_many :user_followings
  has_many :followings, through: :user_followings, source: :user_following

  has_many :user_followers, foreign_key: :user_following, class_name: 'UserFollowing'
  has_many :followers, through: :user_followers, source: :user

  validates :name, presence: true, length: { maximum: 127 }
end
