FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence }
    association :post
    association :user 

    trait :anonymous do
      anonymous { true }
      user { nil } 
    end
  end
end