class TeamMembership < ApplicationRecord
  has_paper_trail
  belongs_to :user
  belongs_to :team

  validates :user_id, presence: true, uniqueness: { scope: :team_id }
  validates :role, inclusion: { in: %w[member leader admin] }

  after_initialize :set_default_role

  private

  def set_default_role
    self.role ||= 'member'
  end
end
