class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :user_id, presence: true
  validates :user_id, uniqueness: {
    scope: :project_id,
    message: 'jest już członkiem tego projektu'
  }
  validate :user_belongs_to_team

  def user_belongs_to_team
    return if user.nil? || project.nil? || project.team.nil?

    unless project.team.users.include?(user)
      errors.add(:user, 'musi należeć do zespołu projektu')
    end
  end
end
