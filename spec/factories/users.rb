FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    age { Faker::Number.between(from: 1, to: 100) }
    password { 'password123' }
  end
end
