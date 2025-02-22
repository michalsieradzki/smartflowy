require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    it { should belong_to(:todo_list) }
    it { should belong_to(:assignee).class_name('User').optional }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, in_progress: 1, completed: 2, on_hold: 3) }
  end

  describe '#project' do
    it 'returns associated project through todo_list' do
      project = create(:project)
      todo_list = create(:todo_list, project: project)
      task = create(:task, todo_list: todo_list)

      expect(task.project).to eq(project)
    end
  end
end
