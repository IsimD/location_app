class User < ApplicationRecord
  validates :auth_token, presence: true, uniqueness: true
  has_many :locations
end
