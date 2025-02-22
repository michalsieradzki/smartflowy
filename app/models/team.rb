class Team < ApplicationRecord
  has_paper_trail
  belongs_to :company
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :projects, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :company_id }
  validates :company, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name description company_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[company users]
  end
end
