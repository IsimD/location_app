require "rails_helper"

RSpec.describe API::V1::Areas, type: :request, sidekiq: true do
  let(:area_representer) { %w[id] }
  let!(:default_user) { FactoryBot.create(:user, default_user: true) }

  describe "GET /areas" do
   
  end

  describe "POST /areas" do
    let(:params) do
      {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "properties": {},
            "geometry": {
              "type": "Polygon",
              "coordinates": coordinates_1,
            },
          },
          {
            "type": "Feature",
            "properties": {},
            "geometry": {
              "type": "Polygon",
              "coordinates": coordinates_2,
            },
          },
        ],
      }
    end

    let(:coordinates_1) do
      [
        [
          [
            7.36083984375,
            50.666872321810715,
          ],
          [
            8.76708984375,
            51.52241608253253,
          ],
          [
            9.76708984375,
            52.52241608253253,
          ],
          [
            7.36083984375,
            50.666872321810715,
          ],
        ],
      ]
    end

    let(:coordinates_2) do
      [
        [
          [
            150.666872321810715,
            17.36083984375,
          ],
          [
            151.52241608253253,
            18.76708984375,
          ],
          [
            151.52241608253253,
            17.76708984375,
          ],
          [
            150.666872321810715,
            17.36083984375,
          ],
        ],
        [
          [
            150.666872321810715,
            11.36083984375,
          ],
          [
            151.52241608253253,
            18.76708984375,
          ],
          [
            151.52241608253253,
            18.96708984375,
          ],
          [
            150.666872321810715,
            11.36083984375,
          ],
        ],
      ]
    end

    subject do
      post "/api/v1/areas",
           params: params.to_json,
           headers: {
             "HTTP_ACCEPT": "application/json",
             "CONTENT_TYPE": "application/json",
           }
    end

    it "has correct response" do
      subject
      response_json = JSON.parse(response.body)
      expect(response.status).to eq(201)
      expect(response_json).to eq("message" => "success")
    end

    context "with incorrect params" do
      let(:coordinates_1) do
        [
          [
            [
              150.666872321810715,
              17.36083984375,
            ],
          ],
        ]
      end

      it "will return an error" do
        subject
        response_json = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_json).to eq("message" => "Each area must have at least 4 points")
      end
    end

    context "user without any areas" do
      let!(:existing_area) { FactoryBot.create(:area, user: default_user) }
      it "delete existing area for the user and create 2 new areas" do
        expect { subject }.to change { Area.count }.by(1)
      end

      it "delete existing area" do
        expect { subject }.to change { Area.find_by(id: existing_area.id) }.from(Area).to(nil)
      end
    end
  end
end
