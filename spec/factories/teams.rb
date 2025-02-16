FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    description { "A great team for great projects" }
    company { Company.instance }
  end
end
