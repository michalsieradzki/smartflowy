FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "Company #{n}" }
    description { "A company description" }
  end
end
