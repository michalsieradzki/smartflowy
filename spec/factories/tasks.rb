FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Zadanie #{n}" }
    description { "Opis zadania" }
    association :todo_list
    status { :pending }
    due_date { 1.week.from_now }

    trait :with_assignee do
      after(:build) do |task|
        task.assignee = create(:user, company: task.todo_list.project.company)
      end
    end
  end
end
