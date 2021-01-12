FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "Charli Retriever#{n}" }
    name { "Charli Retriever" }
    url { "http://example.com" }
    avatar_url { "http://example.com/avatar" }
    provider { "github" }
  end
end
