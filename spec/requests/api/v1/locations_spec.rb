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

  describe "GET /locations/:id" do
    subject { get "/api/v1/locations/#{location_id}" }
    let!(:user) { FactoryBot.create(:user, default_user: true) }
    let!(:area) do
      FactoryBot.create(:area, user: user, coordinates: area_coordinates)
    end
    let!(:location) { FactoryBot.create(:location, user: user, coordinates: location_coordinates) }
    let(:area_coordinates) { [[[0, 0], [2, 0], [2, 2], [0, 2], [0, 0]]] }
    let(:location_id) { location.id }
    let(:location_coordinates) { [1.0, 1.0] }

    it "has status 200" do
      subject
      expect(response.status).to eq(200)
    end

    context "point inside on the location" do
      let(:expected_response) do
        {
          id: location.id,
          name: location.name,
          coordinates: location.coordinates,
          inside: true,
        }.as_json
      end

      it "reponse has correct values" do
        subject
        response_json = JSON.parse(response.body)
        expect(response_json).to eq(expected_response)
      end
    end

    context "point outside of the location" do
      let(:location_coordinates) { [5.0, 1.0] }
      let(:expected_response) do
        {
          id: location.id,
          name: location.name,
          coordinates: location.coordinates,
          inside: false,
        }.as_json
      end

      it "reponse has correct values" do
        subject
        response_json = JSON.parse(response.body)
        expect(response_json).to eq(expected_response)
      end
    end

    context "no location with id" do
      let!(:location_id) { location.id + 1000 }
      let(:validation_message) do
        "Can't find location with id #{location_id} for this session, "\
        "it may exist in another session"
      end

      it "has status 422" do
        subject
        expect(response.status).to eq(422)
      end

      it "return an error message" do
        subject
        response_json = JSON.parse(response.body)
        expect(response_json).to eq("message" => validation_message)
      end
    end

    context "without area" do
      let(:area) { nil }
      let(:validation_message) do
        "Can't find areas for this session"
      end

      it "has status 422" do
        subject
        expect(response.status).to eq(422)
      end

      it "return an error message" do
        subject
        response_json = JSON.parse(response.body)
        expect(response_json).to eq("message" => validation_message)
      end
    end

    context "location without coordinates" do
      let(:location_coordinates) { [] }
      let(:validation_message) do
        "The location doesn't have assign coordinates yet, try again later"
      end

      it "has status 422" do
        subject
        expect(response.status).to eq(422)
      end

      it "return an error message" do
        subject
        response_json = JSON.parse(response.body)
        expect(response_json).to eq("message" => validation_message)
      end
    end

    context "location with error during fetching coordinates" do
      let!(:location_error) do
        FactoryBot.create(:location_error, location: location, message: "some error from API")
      end
      let(:validation_message) do
        "The location have error fetching coordinates with value: 'some error from API'"
      end

      it "has status 422" do
        subject
        expect(response.status).to eq(422)
      end

      it "return an error message" do
        subject
        response_json = JSON.parse(response.body)
        expect(response_json).to eq("message" => validation_message)
      end
    end
  end
end
