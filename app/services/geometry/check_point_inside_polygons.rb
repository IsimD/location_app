module Geometry
  class CheckPointInsidePolygons
    def self.call(point:, polygons:)
      new(point, polygons).call
    end

    def initialize(point, polygons)
      @point = @point = point
      @polygons = polygons
    end

    def call
      inside = false
      polygons.each do |polygon|
        break inside = true if point_inside_polygon(polygon)
      end
      inside
    end

    attr_reader :polygons, :point

    private

    def point_inside_polygon(polygon)
      exterior = polygon.first
      interiors = polygon[1..]
      check_object_inside_single_polygon(exterior)
      interiors.each_with_object(excluded_object = []) do |interior|
        excluded_object << true if check_object_inside_single_polygon(interior)
      end
      check_object_inside_single_polygon(exterior) && excluded_object.empty?
    end

    def check_object_inside_single_polygon(single_polygon)
      (0..single_polygon.size - 2).each_with_object(crossing_points = []) do |i|
        if check_sections_intersect(convert_coordinates(single_polygon[i..i + 1]))
          crossing_points << true
        end
      end
      crossing_points.size.odd?
    end

    def check_sections_intersect(section)
      # To avoid the issue with changing coordinates from near Meridan or Equator
      # (ex. change longitude form -170 to 170) we convert checked point to [0,0] coordinates

      ::Geometry::CheckSectionsIntersect.call(section, [[0.0, 0.0], [180.0, 0.0]])
    end

    def convert_coordinates(coordinates)
      coordinates.map do |coordinate|
        [
          convert_longitude(coordinate[0]),
          convert_latitude(coordinate[1]),
        ]
      end
    end

    def convert_longitude(longitude)
      converted_value = longitude - point[0] #-180 to 180
      converted_value -= 360 if converted_value > 180
      converted_value
    end

    def convert_latitude(latitude)
      converted_value = latitude - point[1] #-90 to 90
      converted_value -= 180 if converted_value > 90
      converted_value
    end
  end
end
