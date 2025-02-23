class Task < ApplicationRecord
  belongs_to :todo_list
  belongs_to :assignee, class_name: 'User', optional: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :attachments
  delegate :project, to: :todo_list
  validates :name, presence: true

  enum :status, {
    pending: 0,
    in_progress: 1,
    completed: 2,
    on_hold: 3
  }, default: :pending

  acts_as_list scope: :todo_list

  def self.ransackable_attributes(auth_object = nil)
    %w[name description status todo_list_id assignee_id position due_date created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[todo_list assignee comments attachments]
  end
end
