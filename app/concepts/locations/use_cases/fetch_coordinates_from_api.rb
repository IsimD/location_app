module Locations
  module UseCases
    class FetchCoordinatesFromApi
      NoResultsError = Class.new(StandardError)
      ConnectionError = Class.new(StandardError)

      def self.call_async(location_id:)
        ::Locations::Worker.perform_async(to_s, location_id)
      end

      def self.call(location_id)
        new(location_id).call
      end

      def initialize(location_id)
        @location = find_location(location_id)
      end

      def call
        call_google_api
        begin
          prepare_coordinates
          update_location
        rescue NoResultsError
          add_error_to_location
        end
      end

      private

      def prepare_coordinates
        parse_response
        coordinates
      end

      def parse_response
        @parsed_response = JSON.parse(@result.body)
      end

      def add_error_to_location
        ::Locations::Repository::Commands.add_error_to_location(
          location: @location,
          message: @parsed_response["status"],
        )
      end

      def update_location
        ::Locations::Repository::Commands.update_location(
          location: @location,
          params: { coordinates: coordinates },
        )
      end

      def coordinates
        raise NoResultsError unless @parsed_response["status"] == "OK"

        location = @parsed_response["results"][0]["geometry"]["location"]
        [location["lng"], location["lat"]]
      end

      def address_query
        "address=#{@location.name}"
      end

      def find_location(location_id)
        ::Locations::Repository::Queries.find_location(location_id: location_id)
      end

      def call_google_api
        @result = Faraday.new(url: uri).get
        raise ConnectionError, @result.body unless @result.success?
      end

      def uri
        URI(base_url.to_s)
      end

      def base_url
        "https://maps.googleapis.com/maps/api/geocode/" \
        "json?#{address_query}&key=#{ENV["GOOGLE_API_KEY"]}"
      end
    end
  end
end
