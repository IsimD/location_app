module Locations
  module UseCases
    class Create
      def self.call(user:, params:)
        new(user, params).call
      end

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        @location = create_location_by_name
        fetch_location_coordinates_from_api
        @location
      end

      private

      def create_location_by_name
        ::Locations::Repository::Commands.create_location_for_user(user: @user, name: name)
      end

      def fetch_location_coordinates_from_api
        ::Locations::UseCases::FetchCoordinatesFromApi.call_async(location_id: @location.id)
      end

      def name
        @params.fetch(:name)
      end
    end
  end
end
