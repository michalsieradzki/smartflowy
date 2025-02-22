class User < ApplicationRecord
  has_paper_trail
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :managed_projects, class_name: 'Project', foreign_key: 'project_manager_id'
  has_many :project_members
  has_many :projects, through: :project_members

  enum :role, {
    superadmin: 0,
    company_admin: 1,
    project_manager: 2,
    user: 3
  }

  validates :company, presence: true
  validates :role, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  scope :active, -> { where(disabled: false) }
  scope :disabled, -> { where(disabled: true) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def disable!
    update!(disabled: true)
  end

  def enable!
    update!(disabled: false)
  end

  def destroy
    if disabled?
      update!(disabled: false)
    else
      update!(disabled: true)
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[email first_name last_name role company_id position created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[company teams]
  end
end
