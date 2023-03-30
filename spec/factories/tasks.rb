FactoryBot.define do
  factory :task do
    title { Faker::String.random(length: 4) }
    description { Faker::String.random(length: 10) }
    due_date { Faker::Date.forward(days: 10) }
    completed { false }
  end
end
