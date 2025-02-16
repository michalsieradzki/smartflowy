class Team < ApplicationRecord
  belongs_to :company
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships

  validates :name, presence: true, uniqueness: { scope: :company_id }
  validates :company, presence: true
end
