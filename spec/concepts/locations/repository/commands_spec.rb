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
end
