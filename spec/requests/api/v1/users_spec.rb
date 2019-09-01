require "rails_helper"

RSpec.describe API::V1::Users, type: :request do
  let(:user_representer) { %w[id auth_token] }
  describe "POST /registrations" do
    subject { post "/api/v1/users/registrations" }
    it "create new user" do
      expect { subject }.to change { User.count }.by(1)
    end

    it "has correct response" do
      subject
      response_json = JSON.parse(response.body)
      expect(response.status).to eq(201)
      expect(response_json.keys).to include(*user_representer)
      expect(response_json.keys.size).to eq(user_representer.size)
    end
  end

  describe "GET /me" do
    subject { get "/api/v1/users/me", headers: headers }
    let!(:registered_user)  { FactoryBot.create :user, default_user: false }
    let!(:default_user)     { FactoryBot.create :user, default_user: true }

    context "without authorization" do
      let(:headers) { {} }

      it "return params for default user" do
        subject
        response_json = JSON.parse(response.body)
        expect(response_json["id"]).to eq(default_user.id)
        expect(response_json["auth_token"]).to eq(default_user.auth_token)
      end

      it "has correct response" do
        subject
        response_json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_json.keys).to include(*user_representer)
        expect(response_json.keys.size).to eq(user_representer.size)
      end
    end

    context "with authorization" do
      let(:headers) { { "Authorization": "Bearer #{registered_user.auth_token}" } }
      it "has correct response" do
        subject
        response_json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_json.keys).to include(*user_representer)
        expect(response_json.keys.size).to eq(user_representer.size)
      end

      it "return params for authenticated user" do
        subject
        response_json = JSON.parse(response.body)
        expect(response_json["id"]).to eq(registered_user.id)
        expect(response_json["auth_token"]).to eq(registered_user.auth_token)
      end
    end
  end
end
