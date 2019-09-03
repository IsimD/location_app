require "rails_helper"

RSpec.describe Locations::UseCases::FetchCoordinatesFromApi do
  subject { described_class.call(location.id) }
  let(:location) { FactoryBot.create(:location, coordinates: []) }
  before do
    stub_request(:get, %r{^https://maps.googleapis.com/maps/api/geocode\D*})
      .to_return(body: response)
  end

  context "correct response from google api" do
    let(:response) do
      {
        results: [geometry: { location: { lat: 33.333, lng: 44.444 } }],
        status: "OK",
      }.to_json
    end

    it "update location coordinates" do
      expect { subject }.to change { location.reload.coordinates }.from([]).to([33.333, 44.444])
    end
  end

  context "error from api" do
    let(:response) do
      {
        results: [],
        status: "ZERO_RESULTS",
      }.to_json
    end

    it "add error to location" do
      expect { subject }.to change { location.reload.location_error }.from(nil).to(LocationError)
    end
  end
end
