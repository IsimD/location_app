class User < ApplicationRecord
  validates :auth_token, presence: true, uniqueness: true
end
