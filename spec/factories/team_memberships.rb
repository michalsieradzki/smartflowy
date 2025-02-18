FactoryBot.define do
  factory :team_membership do
    association :team
    association :user
    role { 'member' }

    trait :with_associations do
      after(:build) do |team_membership|
        team_membership.team ||= build(:team)
        team_membership.user ||= build(:user)
      end
    end
  end
end
