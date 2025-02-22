RSpec.describe ProjectMember, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it 'validates uniqueness of user per project' do
      company = create(:company)
      user = create(:user, company: company)
      project = create(:project, company: company)

      # Wymuszamy walidację przy pierwszym zapisie
      first = create(:project_member, project: project, user: user)
      duplicate = build(:project_member, project: project, user: user)
      duplicate.valid? # Ważne: wywołujemy valid? przed sprawdzeniem błędów

      expect(duplicate).not_to be_valid
      expect(duplicate.errors.full_messages).to include('User jest już członkiem tego projektu')
    end
  end
end
