class TodoList < ApplicationRecord
  belongs_to :project
  has_many :tasks, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true

  acts_as_list scope: :project
end
