RSpec.describe Project, type: :model do
  describe 'custom validations' do
    it 'validates project manager role' do
      team = create(:team)
      company = team.company
      regular_user = create(:user, role: :user, company: company)
      create(:team_membership, team: team, user: regular_user)

      # Wyłączamy automatyczne tworzenie managera w factory
      project = build(:project, team: team, project_manager: regular_user, without_manager: true)
      project.valid?

      expect(project).not_to be_valid
      expect(project.errors[:project_manager]).to include('musi być kierownikiem projektu lub administratorem firmy')
    end
  end
end
