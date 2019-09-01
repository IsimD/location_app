FactoryBot.define do
  factory :user do
    auth_token { SecureRandom.hex }
    default_user { false }
  end
end
