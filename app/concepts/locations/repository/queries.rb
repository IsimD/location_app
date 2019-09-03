module Locations
  module Repository
    class Queries
      class << self
        def find_location(location_id:)
          Location.find(location_id)
        end
      end
    end
  end
end
