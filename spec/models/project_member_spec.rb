RSpec.describe ProjectMember, type: :model do
  describe 'validations' do
    it 'validates uniqueness of user per project' do
      team = create(:team)
      user = create(:user)
      create(:team_membership, team: team, user: user)
      project = create(:project, team: team)

      create(:project_member, project: project, user: user)
      duplicate = build(:project_member, project: project, user: user)
      duplicate.valid?

      # Zmiana sprawdzenia błędu
      expect(duplicate.errors.full_messages).to include('User jest już członkiem tego projektu')
    end
  end
end
