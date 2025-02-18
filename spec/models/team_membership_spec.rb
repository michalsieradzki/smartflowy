# spec/models/team_membership_spec.rb
require 'rails_helper'

RSpec.describe TeamMembership, type: :model do
  describe 'validations' do
    let(:team) { create(:team) }
    let(:user) { create(:user) }
    subject { create(:team_membership, team: team, user: user) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:team_id) }

    it 'uses member as default role' do
      membership = described_class.new
      expect(membership.role).to eq('member')
    end

    it 'validates role inclusion' do
      should validate_inclusion_of(:role).in_array(%w[member leader admin])
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:team) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      team = create(:team)
      user = create(:user)
      membership = build(:team_membership, team: team, user: user)
      expect(membership).to be_valid
    end
  end
end
