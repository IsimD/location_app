require "rails_helper"

RSpec.describe API::V1::Locations, type: :request, sidekiq: true do
  let(:location_representer) { %w[id] }
  describe "POST /locations" do
    subject { post "/api/v1/locations", params: { name: 123 } }
    it "create new location" do
      expect { subject }.to change { Location.count }.by(1)
    end

    it "has correct response" do
      subject
      response_json = JSON.parse(response.body)
      expect(response.status).to eq(201)
      expect(response_json.keys).to include(*location_representer)
      expect(response_json.keys.size).to eq(location_representer.size)
    end

    it "it run background job" do
      expect { subject }.to change { Locations::Worker.jobs.size }.by(1)
    end
  end
end
