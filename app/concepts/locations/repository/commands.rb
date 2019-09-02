module Locations
  module Repository
    class Commands
      class << self
        def create_location_for_user(user:, name:)
          location = Location.new(user: user, name: name)
          location.save!
          location
        end
      end
    end
  end
end
