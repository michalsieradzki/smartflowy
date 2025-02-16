class TeamMembership < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :role, presence: true,
                  inclusion: { in: %w[member leader admin] }
  validates :user_id, uniqueness: { scope: :team_id }
end
