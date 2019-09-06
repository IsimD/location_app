module Areas
  module Representers
    class Basic
      class << self
        def call(area:)
          {
            coordinates: area.coordinates,
          }
        end
      end
    end
  end
end
