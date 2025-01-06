FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence }
    association :post
    association :user 

    trait :anonymous do
      user { nil } 
    end
  end
end