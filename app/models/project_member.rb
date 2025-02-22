class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :user_id, uniqueness: {
    scope: :project_id,
    message: 'jest już członkiem tego projektu'
  }
  validate :user_belongs_to_company

  private

  def user_belongs_to_company
    return if user.nil? || project.nil? || project.company.nil?

    unless user.company_id == project.company_id
      errors.add(:user, 'musi należeć do tej samej firmy')
    end
  end
end
