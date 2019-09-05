require "rails_helper"

RSpec.describe Geometry::CheckPointInsidePolygons do
  subject { described_class.call(point: point, polygons: polygons) }
  let(:point) { [1.0, 1.0] }
  let(:polygons) { [[[[0.0, 0.0], [2.0, 0.0], [2.0, 2.0], [0.0, 2.0], [0.0, 0.0]]]] }

  context "point inside" do
    it "return true" do
      expect(subject).to eq(true)
    end
  end

  context "point outside" do
    let(:point) { [5.0, 0.0] }
    it "return false" do
      expect(subject).to eq(false)
    end
  end
end
