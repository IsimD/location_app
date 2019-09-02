module Locations
  module Representers
    class Minimum
      class << self
        def call(location:)
          {
            id: location.id,
          }
        end
      end
    end
  end
end
