module Geometry
  class CheckSectionsIntersect
    def self.call(section_1, section_2)
      new(section_1, section_2).call
    end

    def initialize(section_1, section_2)
      @a = section_1[0]
      @b = section_1[1]
      @c = section_2[0]
      @d = section_2[1]
    end

    attr_reader :a, :b, :c, :d, :v1, :v2, :v3, :v4, :vectors_intersect, :common_points

    def call
      calculate_vectors
      check_if_vectors_intersect
      check_common_points
      intersect?
    end

    private

    def intersect?
      vectors_intersect || common_points
    end

    def check_common_points
      e1 = (v1 == 0 && check_common_points_for(c, d, a))
      e2 = (v2 == 0 && check_common_points_for(c, d, b))
      e3 = (v3 == 0 && check_common_points_for(a, b, c))
      e4 = (v4 == 0 && check_common_points_for(a, b, d))

      @common_points = e1 || e2 || e3 || e4
    end

    def check_if_vectors_intersect
      @vectors_intersect =
        (v1 * v2 < 0 && v3 * v4 < 0) ||
        ((v1 > 0 && v2 < 0 || v1 < 0 && v2 > 0) &&
        (v3 > 0 && v4 < 0 || v3 < 0 && v4 > 0))
    end

    def calculate_vectors
      @v1 = vector_product(c, d, a)
      @v2 = vector_product(c, d, b)
      @v3 = vector_product(a, b, c)
      @v4 = vector_product(a, b, d)
    end

    def vector_product(a, b, z)
      x1 = z[0] - a[0]
      y1 = z[1] - a[1]
      x2 = b[0] - a[0]
      y2 = b[1] - a[1]

      x1 * y2 - x2 * y1
    end

    def check_common_points_for(a, b, c)
      [a.first, b.first].min <= c.first &&
        c.first <= [a.first, b.first].max &&
        [a.second, b.second].min <= c.second &&
        c.second <= [a.second, b.second].max
    end
  end
end
