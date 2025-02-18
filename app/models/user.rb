class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships

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
end
