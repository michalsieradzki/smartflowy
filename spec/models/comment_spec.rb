require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it 'validates presence of content' do
      task = create(:task)
      user = create(:user)
      comment = Comment.new(commentable: task, user: user)

      comment.valid?
      expect(comment.errors[:content]).to include('nie może być pusta')
    end
  end
end
