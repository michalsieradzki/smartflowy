FactoryBot.define do
  factory :todo_list do
    sequence(:name) { |n| "Lista #{n}" }
    association :project
  end
end
