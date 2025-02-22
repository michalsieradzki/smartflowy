FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Projekt #{n}" }
    description { "Opis przykładowego projektu" }
    association :company

    transient do
      without_manager { false }
    end

    after(:build) do |project, evaluator|
      unless evaluator.without_manager
        manager = create(:user,
          role: :project_manager,
          company: project.company
        )
        project.project_manager = manager
      end
    end
  end
end
