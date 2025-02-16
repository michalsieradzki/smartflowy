require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:company) { create(:company) }

  # Zmieńmy sposób tworzenia użytkowników
  let!(:superadmin) do
    create(:user,
           email: 'superadmin@example.com',
           password: 'password123',
           role: :superadmin,
           company: company)
  end

  let!(:company_admin) do
    create(:user,
           email: 'company_admin@example.com',
           password: 'password123',
           role: :company_admin,
           company: company)
  end

  let!(:regular_user) do
    create(:user,
           email: 'user@example.com',
           password: 'password123',
           role: :user,
           company: company)
  end

  describe 'GET #index' do
    context 'as superadmin' do
      before do
        warden = double
        allow(request.env['warden']).to receive(:authenticate!).and_return(superadmin)
        allow(controller).to receive(:current_user).and_return(superadmin)
      end

      it 'returns success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns all users as @users' do
        users = create_list(:user, 3, company: company)
        get :index
        actual_users = assigns(:users).to_a

        expect(actual_users).to include(superadmin)
        users.each { |user| expect(actual_users).to include(user) }
      end
    end

    context 'as company_admin' do
      before { sign_in company_admin }

      it 'assigns only company users as @users' do
        other_company = create(:company)
        company_users = create_list(:user, 2, company: company)
        other_users = create_list(:user, 2, company: other_company)

        get :index
        actual_users = assigns(:users).to_a

        expect(actual_users).to include(company_admin)
        company_users.each { |user| expect(actual_users).to include(user) }
        other_users.each { |user| expect(actual_users).not_to include(user) }
      end
    end

    context 'as regular user' do
      before { sign_in regular_user }

      it 'redirects to root path when access denied' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end
  end

  describe 'GET #new' do
    context 'as admin' do
      before { sign_in superadmin }

      it 'returns success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new user as @user' do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end

  describe 'POST #create' do
    context 'as superadmin' do
      before { sign_in superadmin }

      context 'with valid params' do
        let(:valid_attributes) do
          {
            email: 'new@example.com',
            password: 'password123',
            first_name: 'John',
            last_name: 'Doe',
            role: 'user',
            company_id: company.id
          }
        end

        it 'creates a new User' do
          expect {
            post :create, params: { user: valid_attributes }
          }.to change(User, :count).by(1)
        end

        it 'redirects to users index' do
          post :create, params: { user: valid_attributes }
          expect(response).to redirect_to(admin_users_path)
        end
      end

      context 'with invalid params' do
        let(:invalid_attributes) do
          {
            email: '',
            password: '',
            first_name: '',
            last_name: ''
          }
        end

        it 'does not create a new user' do
          expect {
            post :create, params: { user: invalid_attributes }
          }.not_to change(User, :count)
        end

        it 're-renders the new template' do
          post :create, params: { user: invalid_attributes }
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user, company: company) }

    context 'as superadmin' do
      before { sign_in superadmin }

      it 'returns success response' do
        get :edit, params: { id: user.id }
        expect(response).to be_successful
      end

      it 'assigns the requested user as @user' do
        get :edit, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user, company: company) }

    context 'as superadmin' do
      before { sign_in superadmin }

      context 'with valid params' do
        let(:new_attributes) do
          {
            first_name: 'Jane',
            last_name: 'Smith'
          }
        end

        it 'updates the requested user' do
          put :update, params: { id: user.id, user: new_attributes }
          user.reload
          expect(user.first_name).to eq('Jane')
          expect(user.last_name).to eq('Smith')
        end

        it 'redirects to users index' do
          put :update, params: { id: user.id, user: new_attributes }
          expect(response).to redirect_to(admin_users_path)
        end
      end
    end
  end
end
