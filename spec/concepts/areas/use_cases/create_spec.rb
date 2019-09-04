require "rails_helper"

RSpec.describe Areas::UseCases::Create do
  subject { described_class.call(user: user, params: params) }
  let(:user)          { double("user") }
  let(:params)        { { "features": coordinates }.as_json }
  let(:coordinates)   { [[1, 2]] }
  let(:repository_command)  { Areas::Repository::Commands }
  let(:validator)           { Areas::Validators::Coordinates }

  before do
    allow_any_instance_of(repository_command).to receive(:create_new_area)
    allow_any_instance_of(repository_command).to receive(:destroy_all_areas)
    allow(validator).to receive(:new).and_call_original
    allow_any_instance_of(described_class)
      .to receive(:prepare_coords_param).and_return([coordinates])
  end

  it "run proper services" do
    expect_any_instance_of(validator).to receive(:call)
    expect_any_instance_of(repository_command).to receive(:destroy_all_areas)
    expect_any_instance_of(repository_command)
      .to receive(:create_new_area).with(coordinates: coordinates)
    subject
  end
end
