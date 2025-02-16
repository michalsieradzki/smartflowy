require 'rails_helper'

RSpec.describe TeamMembership, type: :model do
  describe 'validations' do
    let(:company) { create(:company) }
    let(:team) { create(:team, company: company) }
    let(:user) { create(:user, company: company) }

    subject { create(:team_membership, user: user, team: team, role: 'member') }

    it { should validate_presence_of(:role) }
    it { should validate_inclusion_of(:role).in_array(%w[member leader admin]) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:team_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:team) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      membership = build(:team_membership)
      expect(membership).to be_valid
    end
  end
end
