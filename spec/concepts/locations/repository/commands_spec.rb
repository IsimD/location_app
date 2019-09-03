require "rails_helper"

RSpec.describe Locations::Repository::Commands do
  describe ":create_location_for_user" do
    subject { described_class.create_location_for_user(user: user, name: name) }
    let(:user) { FactoryBot.create(:user) }
    let(:name) { "some name" }

    it "create location for user" do
      expect { subject }.to change { user.locations.count }.by(1)
    end

    it "create location with corrent name" do
      location = subject
      expect(location.name).to eq(name)
    end

    it "return created location" do
      expect(subject).to be_a_kind_of(Location)
    end
  end

  describe "#update_location" do
    subject { described_class.update_location(location: location, params: params) }
    let!(:location) { FactoryBot.create(:location, coordinates: "[]") }
    let(:params) { { coordinates: [12.0, 12.23] } }

    it "update location" do
      expect { subject }.to change { location.reload.coordinates }.from([]).to([12.0, 12.23])
    end

    it "return true" do
      expect(subject).to be_a_kind_of(TrueClass)
    end
  end

  describe "#add_error_to_location" do
    subject { described_class.add_error_to_location(location: location, message: message) }
    let!(:location) { FactoryBot.create(:location) }
    let(:message) { "Some info about failure" }

    it "create new error for location" do
      expect { subject }.to change { location.reload.location_error }.from(nil).to(LocationError)
    end

    it "return location error" do
      expect(subject).to be_a_kind_of(LocationError)
    end
  end
end
