FactoryBot.define do
    factory :comment do
      content { Faker::Lorem.sentence }
      association :post
      association :user 
    end
  end