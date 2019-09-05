module Locations
  module Repository
    class Queries
      class << self
        def find_location(location_id:)
          Location.find(location_id)
        end

        def find_location_for_user(user_id:, location_id:)
          User.find(user_id).locations.find_by(id: location_id)
        end

        def find_areas_for_user(user_id:)
          User.find(user_id).areas
        end
      end
    end
  end
end
