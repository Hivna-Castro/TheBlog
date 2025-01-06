FactoryBot.define do
    factory :user do
      name { Faker::Name.name }
      email { Faker::Internet.email }
      password { "password123" }
      password_confirmation { "password123" }

      trait :with_reset_password_token do
        reset_password_token { SecureRandom.hex(10) }
        reset_password_sent_at { Time.current }
      end
    end
  end