module Locations
  module UseCases
    class CheckLocation
      CheckLocationError = Class.new(StandardError)

      def self.call(user:, id:)
        new(user, id).call
      end

      def initialize(user, id)
        @id = id
        @user = user
        @location = find_location
      end

      def call
        validate_location
        find_areas
        validate_areas
        check_point_inside_area
        represent
      end

      attr_reader :location, :id, :user, :areas, :inside

      private

      def find_location
        ::Locations::Repository::Queries.find_location_for_user(user_id: user.id, location_id: id)
      end

      def find_areas
        @areas = ::Locations::Repository::Queries.find_areas_for_user(user_id: user.id)
      end

      def validate_location
        check_location_present
        check_location_errors
        check_location_coordinates_presents
      end

      def check_location_present
        return if location

        raise CheckLocationError,
              "Can't find location with id #{id} for this session, it may exist in another session"
      end

      def check_location_coordinates_presents
        return unless location.coordinates == []

        raise CheckLocationError,
              "The location doesn't have assign coordinates yet, try again later"
      end

      def check_location_errors
        return unless location.location_error

        raise CheckLocationError,
              "The location have error fetching coordinates with value: "\
              "'#{location.location_error.message}'"
      end

      def validate_areas
        return if @areas.any?

        raise CheckLocationError,
              "Can't find areas for this session"
      end

      def represent
        {
          id: location.id,
          name: location.name,
          coordinates: location.coordinates,
          inside: inside,
        }
      end

      def check_point_inside_area
        @inside = ::Geometry::CheckPointInsidePolygons.call(
          point: location.coordinates,
          polygons: areas.map(&:coordinates),
        )
      end
    end
  end
end
