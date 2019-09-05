FactoryBot.define do
  factory :location_error do
    location
    message { "some API error" }
  end
end
