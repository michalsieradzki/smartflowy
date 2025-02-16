require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'validations' do
    subject { create(:team) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:company) }
    it { should validate_uniqueness_of(:name).scoped_to(:company_id) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:team)).to be_valid
    end
  end
end
