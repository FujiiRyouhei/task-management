FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    due_date { "2023-03-31" }
    completed { false }
  end
end
