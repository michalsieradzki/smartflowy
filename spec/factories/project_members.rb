FactoryBot.define do
  factory :project_member do
    association :project
    association :user
  end
end
