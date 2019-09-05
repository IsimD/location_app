require "rails_helper"

RSpec.describe Geometry::CheckSectionsIntersect do
  subject { described_class.call(section_1, section_2) }
  let(:section_1) { [[2.0, 0.0], [2.0, 2.0]] }
  let(:section_2) { [[1.0, 1.0], [5.0, 1.0]] }

  context "intersect sections" do
    it "return true" do
      expect(subject).to eq(true)
    end
  end

  context "not intersect sections" do
    let(:section_2) { [[3.0, 3.0], [5.0, 0.0]] }
    it "return false" do
      expect(subject).to eq(false)
    end
  end
end
