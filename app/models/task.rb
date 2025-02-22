class Task < ApplicationRecord
  belongs_to :todo_list
  belongs_to :assignee, class_name: 'User', optional: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :attachments

  validates :name, presence: true

  enum :status, {
    pending: 0,
    in_progress: 1,
    completed: 2,
    on_hold: 3
  }, default: :pending

  acts_as_list scope: :todo_list

  def project
    todo_list.project
  end
end
