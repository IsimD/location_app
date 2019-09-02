module Locations
  module UseCases
    class FetchCoordinatesFromApi
      def self.call_async(location_id:)
        ::Locations::Worker.perform_async(to_s, location_id)
      end

      def self.call
        new.call
      end

      def initialize; end

      def call; end
    end
  end
end
