class Location < ApplicationRecord
  belongs_to :user
  has_one :location_error
end
