class Project < ApplicationRecord
  belongs_to :company
  belongs_to :project_manager, class_name: 'User'
  has_many :project_members, dependent: :destroy
  has_many :users, through: :project_members
  has_many_attached :attachments

  validates :name, presence: true
  validates :project_manager_id, presence: true
  validate :project_manager_has_correct_role
  validate :project_manager_belongs_to_company

  def self.ransackable_attributes(auth_object = nil)
    %w[name description project_manager_id company_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[company project_manager project_members users]
  end

  private

  def project_manager_belongs_to_company
    return if project_manager.nil? || company.nil?

    unless project_manager.company_id == company_id
      errors.add(:project_manager, 'musi należeć do tej samej firmy')
    end
  end

  def project_manager_has_correct_role
    return if project_manager.nil?

    unless project_manager.project_manager? || project_manager.company_admin?
      errors.add(:project_manager, 'musi być kierownikiem projektu lub administratorem firmy')
    end
  end
end
