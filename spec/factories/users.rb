FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    position { Faker::Job.title }
    timezone { 'UTC' }
    role { :user }
    disabled { false }
    association :company

    trait :disabled do
      disabled { true }
    end

    trait :superadmin do
      role { :superadmin }
    end

    trait :company_admin do
      role { :company_admin }
    end

    trait :project_manager do
      role { :project_manager }
    end
  end
end
