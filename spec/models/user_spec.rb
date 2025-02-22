require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:company) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:managed_projects).class_name('Project') }
    it { should have_many(:project_members) }
    it { should have_many(:projects).through(:project_members) }

  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(superadmin: 0, company_admin: 1, project_manager: 2, user: 3) }
  end

  describe 'scopes' do
    let!(:active_user) { create(:user, disabled: false) }
    let!(:disabled_user) { create(:user, disabled: true) }

    describe '.active' do
      it 'returns only active users' do
        expect(User.active).to include(active_user)
        expect(User.active).not_to include(disabled_user)
      end
    end

    describe '.disabled' do
      it 'returns only disabled users' do
        expect(User.disabled).to include(disabled_user)
        expect(User.disabled).not_to include(active_user)
      end
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

    describe '#full_name' do
      it 'returns concatenated first and last name' do
        expect(user.full_name).to eq('John Doe')
      end
    end

    describe '#disable!' do
      it 'disables the user' do
        expect { user.disable! }.to change { user.disabled }.from(false).to(true)
      end
    end

    describe '#enable!' do
      let(:disabled_user) { create(:user, disabled: true) }

      it 'enables the user' do
        expect { disabled_user.enable! }.to change { disabled_user.disabled }.from(true).to(false)
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'creates active user by default' do
      user = create(:user)
      expect(user).not_to be_disabled
    end

    describe 'roles' do
      it 'creates superadmin' do
        user = create(:user, :superadmin)
        expect(user).to be_superadmin
      end

      it 'creates company admin' do
        user = create(:user, :company_admin)
        expect(user).to be_company_admin
      end

      it 'creates project manager' do
        user = create(:user, :project_manager)
        expect(user).to be_project_manager
      end

      it 'creates regular user' do
        user = create(:user)
        expect(user).to be_user
      end
    end
  end
end
