require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'attachments' do
    it 'allows attaching a valid logo' do
      company = Company.instance
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'logo.png'), 'image/png')
      company.logo.attach(file)
      expect(company.logo).to be_attached
    end

    it 'validates logo content type' do
      company = Company.instance
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'logo.csv'), 'text/plain')
      company.logo.attach(file)
      expect(company).not_to be_valid
    end
  end

  describe '.instance' do
    it 'returns the same instance' do
      company1 = Company.instance
      company2 = Company.instance

      expect(company1).to eq(company2)
    end

    it 'creates a company if none exists' do
      expect {
        Company.instance
      }.to change(Company, :count).from(0).to(1)
    end
  end
end
