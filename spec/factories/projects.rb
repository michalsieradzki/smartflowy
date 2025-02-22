FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Projekt #{n}" }
    description { "Opis przykładowego projektu" }
    association :team

    transient do
      without_manager { false }
    end

    after(:build) do |project, evaluator|
      unless evaluator.without_manager
        manager = create(:user, role: :project_manager, company: project.team.company)
        create(:team_membership, team: project.team, user: manager)
        project.project_manager = manager
      end
    end
  end
end
