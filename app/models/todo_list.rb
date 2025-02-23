class TodoList < ApplicationRecord
  belongs_to :project
  has_many :tasks, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true

  acts_as_list scope: :project


  def self.ransackable_attributes(auth_object = nil)
    %w[name project_id position created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[project tasks]
  end
end
