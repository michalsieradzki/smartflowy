class Project < ApplicationRecord
  belongs_to :team
  belongs_to :project_manager, class_name: 'User'
  has_many :project_members, dependent: :destroy
  has_many :users, through: :project_members
  has_many_attached :attachments

  validates :name, presence: true
  validates :project_manager_id, presence: true
  validate :project_manager_has_correct_role
  validate :project_manager_belongs_to_team

  def project_manager_has_correct_role
    return if project_manager.nil?

    unless project_manager.project_manager? || project_manager.company_admin?
      errors.add(:project_manager, 'musi być kierownikiem projektu lub administratorem firmy')
    end
  end

  def project_manager_belongs_to_team
    return if project_manager.nil? || team.nil?

    unless team.users.include?(project_manager)
      errors.add(:project_manager, 'musi należeć do zespołu projektu')
    end
  end
end
