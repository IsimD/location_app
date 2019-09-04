FactoryBot.define do
  factory :area do
    coordinates { [[1, 0.2], [0, 0.1], [1, 0.3], [1, 0.2]] }
    user
  end
end
