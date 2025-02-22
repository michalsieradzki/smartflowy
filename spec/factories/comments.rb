FactoryBot.define do
  factory :comment do
    content { "Przykładowy komentarz" }
    association :user

    trait :for_task do
      association :commentable, factory: :task
    end
  end
end
