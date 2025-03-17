FactoryBot.define do
  factory :notification do
    recipient { nil }
    actor { nil }
    notifiable { nil }
    message { "MyString" }
    notification_type { 1 }
    read_at { "2025-03-17 07:41:54" }
  end
end
