require "rails_helper"

RSpec.describe Locations::UseCases::Create do
  subject { described_class.call(user: user, params: params) }
  let(:user)          { double("user") }
  let(:location)      { double("location", id: location_id) }
  let(:name)          { double("name") }
  let(:location_id)   { double("location_id") }
  let(:params)        { { name: name } }
  let(:repository_command)        { Locations::Repository::Commands }
  let(:fetch_coordinates_service) { Locations::UseCases::FetchCoordinatesFromApi }

  before do
    allow(repository_command)
      .to receive(:create_location_for_user).with(user: user, name: name).and_return(location)
    allow(fetch_coordinates_service)
      .to receive(:call_async).with(location_id: location_id)
  end

  it "return correct value" do
    expect(subject).to be(location)
  end

  it "run proper services" do
    expect(repository_command).to receive(:create_location_for_user).with(user: user, name: name)
    expect(fetch_coordinates_service).to receive(:call_async).with(location_id: location_id)
    subject
  end
end
