require 'rails_helper'

RSpec.describe TodoList, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
