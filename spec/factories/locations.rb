FactoryBot.define do
  factory :location do
    name { "San Fransisco" }
    coordinates { "[]" }
    user
  end
end
