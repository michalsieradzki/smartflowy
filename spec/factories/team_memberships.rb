FactoryBot.define do
  factory :team_membership do
    association :user
    association :team
    role { %w[member leader admin].sample }
  end
end
