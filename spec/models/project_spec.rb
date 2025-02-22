RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:project_manager).class_name('User') }
    it { should have_many(:project_members).dependent(:destroy) }
    it { should have_many(:users).through(:project_members) }
    it { should have_many_attached(:attachments) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:project_manager_id) }
  end

  describe 'custom validations' do
    let(:company) { create(:company) }
    let(:regular_user) { create(:user, role: :user, company: company) }
    let(:project_manager) { create(:user, role: :project_manager, company: company) }
    let(:different_company_user) { create(:user, company: create(:company)) }

    it 'validates project manager role' do
      project = build(:project, company: company, project_manager: regular_user, without_manager: true)

      project.valid?
      expect(project).not_to be_valid
      expect(project.errors[:project_manager]).to include('musi być kierownikiem projektu lub administratorem firmy')
    end

    it 'validates project manager belongs to company' do
      different_company_manager = create(:user, role: :project_manager, company: create(:company))
      project = build(:project, company: company, project_manager: different_company_manager, without_manager: true)

      project.valid?
      expect(project).not_to be_valid
      expect(project.errors[:project_manager]).to include('musi należeć do tej samej firmy')
    end

    it 'validates users belong to the same company' do
      project = create(:project, company: company, project_manager: project_manager)
      project_member = build(:project_member, project: project, user: different_company_user)

      expect(project_member).not_to be_valid
      expect(project_member.errors[:user]).to include('musi należeć do tej samej firmy')
    end

    it 'allows valid project manager' do
      project = build(:project, company: company, project_manager: project_manager)
      expect(project).to be_valid
    end

    it 'allows company admin as project manager' do
      company_admin = create(:user, role: :company_admin, company: company)
      project = build(:project, company: company, project_manager: company_admin)
      expect(project).to be_valid
    end
  end
 end
