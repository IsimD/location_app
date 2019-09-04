module Areas
  module Validators
    class Coordinates
      InvalidParamsError = Class.new(StandardError)
      def initialize(param)
        @param = param
      end

      attr_reader :param

      def call
        valid_type
        valid_presents
        valid_first_and_last_point
        valid_coordinates
        valid_points_amount
        valid_points_numeric
        nil
      end

      private

      def valid_presents
        return if param["geometry"]["coordinates"].present?

        raise InvalidParamsError, "Coordinates can't be empty"
      end

      def valid_coordinates
        param["geometry"]["coordinates"].each do |points|
          points.each do |coord|
            valid_latitude(coord)
            valid_longitude(coord)
          end
        end
      end

      def valid_longitude(coord)
        return if coord.first.to_f >= -180 && coord.first.to_f <= 180

        raise InvalidParamsError, "Each longitude must be between -180 and 180"
      end

      def valid_latitude(coord)
        return if coord.second.to_f >= -90 && coord.second.to_f <= 90

        raise InvalidParamsError, "Each latitude must be beetwon -90 and 90"
      end

      def valid_first_and_last_point
        param["geometry"]["coordinates"].each do |points|
          unless points.first == points.last
            raise InvalidParamsError, "The first point must be the same as the last"
          end
        end
      end

      def valid_points_numeric
        param["geometry"]["coordinates"].flatten.each do |coord|
          raise InvalidParamsError, "All points must be numeric" unless numeric?(coord)
        end
      end

      def valid_points_amount
        param["geometry"]["coordinates"].each do |points|
          raise InvalidParamsError, "Each area must have at least 4 points" unless points.size >= 4
        end
      end

      def numeric?(num)
        return true if num =~ /\A\d+\Z/

        begin
          true if Float(num)
        rescue StandardError
          false
        end
      end

      def invalid_type_message
        "Invalid feature type, Only Polygon is supported"
      end

      def valid_type
        raise InvalidParamsError, invalid_type_message unless param["geometry"]["type"] == "Polygon"
      end
    end
  end
end
