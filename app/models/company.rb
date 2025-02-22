class Company < ApplicationRecord
  has_one_attached :logo
  has_many :teams, dependent: :destroy
  has_many :users, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :logo, attached: false, content_type: ['image/png', 'image/jpeg', 'image/gif'],
                  size: { less_than: 5.megabytes }

  def self.instance
    first_or_create!(name: 'SmartFlowy')
  end
end
