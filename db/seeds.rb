# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

5.times do |i|
    user = User.create!(
      name: Faker::Name.name,
      email: "user#{i+1}@example.com", 
      password: "password",
      password_confirmation: "password" 
    )
end
  
12.times do
    Tag.create!(name: Faker::Lorem.word)
end
  
10.times do
    post = Post.create!(
      user_id: User.all.sample.id,
      title: Faker::Lorem.sentence(word_count: 3),
      content: Faker::Lorem.words(number: 20).join(' ')
    )
  
    post.tags = Tag.order("RANDOM()").limit(3)
end
  
20.times do |i|
    anonymous = i < 8 
  
    Comment.create!(
      post_id: Post.all.sample.id,
      user_id: anonymous ? nil : User.all.sample.id,  
      content: Faker::Lorem.paragraph,
      anonymous: anonymous
    )
end
  